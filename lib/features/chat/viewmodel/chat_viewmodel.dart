import 'package:flutter/foundation.dart';
import 'package:prostuti/features/chat/model/conversation_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../model/chat_model.dart';
import '../repository/chat_repo.dart';
import '../socket_service.dart';

part 'chat_viewmodel.g.dart';

// Provider to initialize the socket once at app startup
@riverpod
Future<bool> socketInitializer(SocketInitializerRef ref) async {
  final socketService = ChatSocketService();
  return await socketService.initSocket();
}

// Provider for active conversations
@riverpod
class ConversationsNotifier extends _$ConversationsNotifier {
  late final ChatSocketService _socketService;

  @override
  Future<List<Conversation>> build() async {
    _socketService = ChatSocketService();

    // Wait for socket initialization to complete or timeout after 5 seconds
    try {
      // Use the shared socket initializer provider
      final initialized = await ref
          .watch(socketInitializerProvider.future)
          .timeout(const Duration(seconds: 5));

      if (!initialized) {
        debugPrint(
            'Socket initialization failed, but still fetching conversations');
      }
    } catch (e) {
      debugPrint('Socket initialization timeout: $e');
    }

    return _fetchConversations();
  }

  Future<List<Conversation>> _fetchConversations() async {
    final result =
        await ref.read(chatRepositoryProvider).getActiveConversations();

    return result.fold(
      (error) {
        debugPrint('Error fetching conversations: ${error.message}');
        return [];
      },
      (conversations) {
        return conversations.data ?? [];
      },
    );
  }

  Future<void> refreshConversations() async {
    state = const AsyncValue.loading();
    state = AsyncValue.data(await _fetchConversations());
  }
}

// Provider for unread message count
@riverpod
class UnreadMessagesNotifier extends _$UnreadMessagesNotifier {
  @override
  Future<UnreadCountData?> build() async {
    return _fetchUnreadCount();
  }

  Future<UnreadCountData?> _fetchUnreadCount() async {
    final result =
        await ref.read(chatRepositoryProvider).getUnreadMessageCount();

    return result.fold(
      (error) {
        debugPrint('Error fetching unread count: ${error.message}');
        return null;
      },
      (response) {
        return response.data;
      },
    );
  }

  Future<void> refreshUnreadCount() async {
    state = const AsyncValue.loading();
    state = AsyncValue.data(await _fetchUnreadCount());
  }
}

// Provider for chat messages in a specific conversation
@riverpod
class ChatMessagesNotifier extends _$ChatMessagesNotifier {
  late final ChatSocketService _socketService;
  bool _isLoadingMore = false;
  int _currentPage = 1;
  bool _hasMoreMessages = true;
  static const int _messagesPerPage = 20;

  @override
  Future<List<ChatMessage>> build(String conversationId) async {
    _socketService = ChatSocketService();

    // Wait for socket initialization to complete or timeout after 5 seconds
    try {
      // Use the shared socket initializer provider
      final initialized = await ref
          .watch(socketInitializerProvider.future)
          .timeout(const Duration(seconds: 5));

      if (!initialized) {
        debugPrint(
            'Socket initialization failed, but still trying to fetch messages');
      }
    } catch (e) {
      debugPrint('Socket initialization timeout in chat messages: $e');
    }

    _setupSocketListeners(conversationId);
    _markConversationAsRead(conversationId);

    ref.onDispose(() {
      _socketService.off('receive_message');
      _socketService.off('typing');
      _socketService.off('stop_typing');
    });

    return _fetchMessages(conversationId);
  }

  Future<List<ChatMessage>> _fetchMessages(
    String conversationId, {
    int page = 1,
    bool append = false,
  }) async {
    final result = await ref.read(chatRepositoryProvider).getChatHistory(
          conversationId: conversationId,
          page: page,
          limit: _messagesPerPage,
        );

    return result.fold(
      (error) {
        debugPrint('Error fetching messages: ${error.message}');
        return append ? state.value ?? [] : [];
      },
      (response) {
        final messages = response.data?.messages ?? [];
        final total = response.data?.total ?? 0;

        // Check if we have more messages to load
        _hasMoreMessages = (page * _messagesPerPage) < total;

        if (append && state.value != null) {
          // Append new messages to existing list
          return [...state.value!, ...messages];
        } else {
          return messages;
        }
      },
    );
  }

  void _setupSocketListeners(String conversationId) {
    // Only join if socket is connected
    if (_socketService.isConnected) {
      // Join the conversation room
      _socketService.joinConversation(conversationId);
    }

    // Listen for new messages
    _socketService.on('receive_message', (data) {
      debugPrint('Received message: $data');

      if (data['conversation_id'] == conversationId) {
        final newMessage = ChatMessage.fromJson(data);

        state = AsyncValue.data([
          newMessage,
          ...state.value ?? [],
        ]);

        // Mark message as read if in this conversation
        _markConversationAsRead(conversationId);

        // Also refresh unread count since we received a new message
        ref.read(unreadMessagesNotifierProvider.notifier).refreshUnreadCount();
      }
    });

    // Listen for typing indicators
    _socketService.on('typing', (data) {
      if (data['conversation_id'] == conversationId &&
          data['user_id'] != null) {
        // Update typing indicator provider
        ref.read(typingUsersProvider.notifier).setUserTyping(
              conversationId,
              data['user_id'],
            );
        debugPrint('User ${data['user_id']} is typing...');
      }
    });

    // Listen for stop typing indicators
    _socketService.on('stop_typing', (data) {
      if (data['conversation_id'] == conversationId &&
          data['user_id'] != null) {
        // Update typing indicator provider
        ref.read(typingUsersProvider.notifier).clearUserTyping(conversationId);
        debugPrint('User ${data['user_id']} stopped typing');
      }
    });
  }

  Future<void> loadMoreMessages(String conversationId) async {
    if (_isLoadingMore || !_hasMoreMessages) return;

    _isLoadingMore = true;
    _currentPage++;

    final messages = await _fetchMessages(
      conversationId,
      page: _currentPage,
      append: true,
    );

    state = AsyncValue.data(messages);
    _isLoadingMore = false;
  }

  Future<void> sendMessage({
    required String conversationId,
    required String recipientId,
    required String message,
  }) async {
    if (message.trim().isEmpty) return;

    final messageData = {
      'conversation_id': conversationId,
      'message': message.trim(),
      'recipient_id': recipientId,
    };

    _socketService.sendMessage(messageData);
  }

  void sendTypingIndicator(String conversationId) {
    _socketService.sendTypingIndicator(conversationId);
  }

  void sendStopTypingIndicator(String conversationId) {
    _socketService.sendStopTypingIndicator(conversationId);
  }

  Future<void> _markConversationAsRead(String conversationId) async {
    await ref.read(chatRepositoryProvider).markMessagesAsRead(conversationId);

    // Refresh unread count
    ref.read(unreadMessagesNotifierProvider.notifier).refreshUnreadCount();
  }
}

// Simple provider to track typing state in a conversation
@riverpod
class TypingUsers extends _$TypingUsers {
  @override
  Map<String, String> build() {
    return {};
  }

  void setUserTyping(String conversationId, String userId) {
    state = {...state, conversationId: userId};
  }

  void clearUserTyping(String conversationId) {
    final newState = Map<String, String>.from(state);
    newState.remove(conversationId);
    state = newState;
  }

  bool isUserTyping(String conversationId) {
    return state.containsKey(conversationId);
  }
}
