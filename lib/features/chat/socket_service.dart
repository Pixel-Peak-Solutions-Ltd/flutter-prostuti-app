import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prostuti/common/helpers/persist_util.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

// FIXED: Use the base URL without /api/v1 for Socket.IO connection
// The Socket.IO server is initialized at the root level in your backend
// const SOCKET_URL = BASE_URL; // This was pointing to your API endpoint (with /api/v1)
const SOCKET_URL =
    'https://resilient-heart-dev.up.railway.app'; // Root URL where Socket.IO server is listening

// Provider to track socket connection status
final socketConnectionStatusProvider = StreamProvider<ConnectionStatus>((ref) {
  return ChatSocketService().connectionStatusStream;
});

// Connection status enum
enum ConnectionStatus {
  disconnected,
  connecting,
  connected,
  connectionError,
  authError
}

class ChatSocketService {
  static final ChatSocketService _instance = ChatSocketService._internal();
  factory ChatSocketService() => _instance;

  final StreamController<ConnectionStatus> _connectionStatusController =
      StreamController<ConnectionStatus>.broadcast();

  Stream<ConnectionStatus> get connectionStatusStream =>
      _connectionStatusController.stream;

  IO.Socket? _socket;
  bool _isConnected = false;
  Timer? _reconnectTimer;
  int _reconnectAttempts = 0;
  static const int _maxReconnectAttempts = 5;
  static const Duration _initialReconnectDelay = Duration(seconds: 2);

  bool _isInitializing = false;
  Completer<bool>? _initCompleter;

  ChatSocketService._internal();

  bool get isConnected => _isConnected;

  // Initialize the socket connection
  Future<bool> initSocket() async {
    // If already connected, return success immediately
    if (_isConnected && _socket != null) {
      debugPrint('Socket already connected');
      return true;
    }

    // If initialization is in progress, wait for it to complete
    if (_isInitializing && _initCompleter != null) {
      debugPrint('Socket initialization already in progress, waiting...');
      return _initCompleter!.future;
    }

    // Set initialization flag and create completion completer
    _isInitializing = true;
    _initCompleter = Completer<bool>();

    _connectionStatusController.add(ConnectionStatus.connecting);

    try {
      // If socket exists, disconnect and dispose before recreating
      if (_socket != null) {
        debugPrint('Cleaning up existing socket');
        _socket!.disconnect();
        _socket!.dispose();
        _socket = null;
      }

      final token = await PersistUtil.getAccessToken();

      if (token == null) {
        debugPrint('Cannot initialize socket: No access token');
        _connectionStatusController.add(ConnectionStatus.authError);
        _isInitializing = false;
        _initCompleter!.complete(false);
        return false;
      }

      debugPrint('Creating socket with URL: $SOCKET_URL');

      // Create socket with the corrected configuration
      _socket = IO.io(
        SOCKET_URL,
        IO.OptionBuilder()
            // Try both transports for more reliable connections
            .setTransports(['websocket', 'polling'])
            .disableAutoConnect()
            // Auth is correctly used in your backend middleware
            .setAuth({'token': token})
            // Optionally add token to headers too for flexibility
            .setExtraHeaders({'Authorization': 'Bearer $token'})
            .setTimeout(10000) // 10 seconds connection timeout
            .setReconnectionAttempts(
                0) // Disable built-in reconnection to use our custom logic
            // These options help ensure a fresh connection
            .enableForceNew()
            .enableReconnection()
            .build(),
      );

      _setupSocketListeners();

      debugPrint('Socket object created, attempting to connect...');
      _socket!.connect();

      // Add a timeout for the initial connection attempt
      Timer(const Duration(seconds: 15), () {
        if (!_isConnected && _isInitializing) {
          debugPrint('Socket connection timeout after 15 seconds');
          _connectionStatusController.add(ConnectionStatus.connectionError);
          _isInitializing = false;
          _initCompleter!.complete(false);
          _attemptReconnect();
        }
      });

      return _initCompleter!.future;
    } catch (e) {
      debugPrint('Error initializing socket: $e');
      _connectionStatusController.add(ConnectionStatus.connectionError);
      _isInitializing = false;
      _initCompleter!.complete(false);
      return false;
    }
  }

  void _setupSocketListeners() {
    _socket?.onConnect((_) {
      debugPrint('Socket connected successfully');
      _isConnected = true;
      _reconnectAttempts = 0;
      _connectionStatusController.add(ConnectionStatus.connected);

      if (_isInitializing &&
          _initCompleter != null &&
          !_initCompleter!.isCompleted) {
        _isInitializing = false;
        _initCompleter!.complete(true);
      }
    });

    _socket?.onDisconnect((_) {
      debugPrint('Socket disconnected');
      _isConnected = false;
      _connectionStatusController.add(ConnectionStatus.disconnected);

      if (_isInitializing &&
          _initCompleter != null &&
          !_initCompleter!.isCompleted) {
        _isInitializing = false;
        _initCompleter!.complete(false);
      }

      _attemptReconnect();
    });

    _socket?.onConnectError((data) {
      debugPrint('Socket connection error: $data');
      _isConnected = false;
      _connectionStatusController.add(ConnectionStatus.connectionError);

      if (_isInitializing &&
          _initCompleter != null &&
          !_initCompleter!.isCompleted) {
        _isInitializing = false;
        _initCompleter!.complete(false);
      }

      _attemptReconnect();
    });

    _socket?.onConnectError((_) {
      debugPrint('Socket connection timeout');
      _isConnected = false;
      _connectionStatusController.add(ConnectionStatus.connectionError);

      if (_isInitializing &&
          _initCompleter != null &&
          !_initCompleter!.isCompleted) {
        _isInitializing = false;
        _initCompleter!.complete(false);
      }

      _attemptReconnect();
    });

    _socket?.on('authenticated', (data) {
      debugPrint('Socket authenticated: $data');
      _connectionStatusController.add(ConnectionStatus.connected);
    });

    _socket?.on('authentication_error', (data) {
      debugPrint('Socket authentication error: $data');
      _isConnected = false;
      _connectionStatusController.add(ConnectionStatus.authError);

      if (_isInitializing &&
          _initCompleter != null &&
          !_initCompleter!.isCompleted) {
        _isInitializing = false;
        _initCompleter!.complete(false);
      }
    });

    _socket?.on('error', (data) {
      debugPrint('Socket error: $data');
    });
  }

  void _attemptReconnect() {
    _reconnectTimer?.cancel();

    if (_reconnectAttempts >= _maxReconnectAttempts) {
      debugPrint('Max reconnect attempts reached');
      return;
    }

    final backoffFactor = _reconnectAttempts + 1;
    final jitter = (backoffFactor / 2) *
        (DateTime.now().millisecondsSinceEpoch % 1000) /
        1000;
    final delaySeconds =
        _initialReconnectDelay.inSeconds * backoffFactor + jitter;

    debugPrint(
        'Attempting reconnect in $delaySeconds seconds (attempt ${_reconnectAttempts + 1})');

    _reconnectTimer = Timer(Duration(seconds: delaySeconds.round()), () {
      if (!_isConnected && _socket != null) {
        _reconnectAttempts++;
        _socket!.connect();
        debugPrint('Reconnect attempt ${_reconnectAttempts}');
      }
    });
  }

  // Disconnect the socket
  void disconnect() {
    _reconnectTimer?.cancel();
    if (_socket != null) {
      _socket!.disconnect();
      _socket!.dispose();
      _socket = null;
    }
    _isConnected = false;
    _connectionStatusController.add(ConnectionStatus.disconnected);
    debugPrint('Socket disconnected');

    _isInitializing = false;
    if (_initCompleter != null && !_initCompleter!.isCompleted) {
      _initCompleter!.complete(false);
    }
  }

  // Listen to a specific event
  void on(String event, Function(dynamic) callback) {
    _socket?.on(event, callback);
  }

  // Stop listening to a specific event
  void off(String event) {
    _socket?.off(event);
  }

  // Emit an event
  void emit(String event, dynamic data) {
    if (_isConnected) {
      _socket?.emit(event, data);
    } else {
      debugPrint('Cannot emit $event: Socket not connected');
    }
  }

  // Emit an event and receive a callback
  void emitWithAck(String event, dynamic data, Function(dynamic) callback) {
    if (_isConnected) {
      _socket?.emitWithAck(event, data, ack: callback);
    } else {
      debugPrint('Cannot emit $event with ACK: Socket not connected');
    }
  }

  // Join a conversation room
  void joinConversation(String conversationId) {
    emit('join_conversation', conversationId);
  }

  // Leave a conversation room
  void leaveConversation(String conversationId) {
    emit('leave_conversation', conversationId);
  }

  // Send a typing indicator
  void sendTypingIndicator(String conversationId) {
    emit('typing', conversationId);
  }

  // Send a stop typing indicator
  void sendStopTypingIndicator(String conversationId) {
    emit('stop_typing', conversationId);
  }

  // Send a message
  void sendMessage(Map<String, dynamic> messageData) {
    emit('send_message', messageData);
  }

  // Send a broadcast request
  void sendBroadcastRequest(Map<String, dynamic> broadcastData) {
    emit('broadcast_request', broadcastData);
  }

  // Clean up resources
  void dispose() {
    _reconnectTimer?.cancel();
    disconnect();
    _connectionStatusController.close();
  }
}
