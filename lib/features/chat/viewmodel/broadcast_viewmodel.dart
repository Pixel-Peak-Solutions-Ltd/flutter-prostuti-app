import 'package:flutter/foundation.dart';
import 'package:prostuti/features/chat/model/broadcast_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../repository/chat_repo.dart';
import '../socket_service.dart';

part 'broadcast_viewmodel.g.dart';

@riverpod
class BroadcastNotifier extends _$BroadcastNotifier {
  late final ChatSocketService _socketService;

  @override
  Future<List<BroadcastRequest>> build() async {
    _socketService = ChatSocketService();
    await _socketService.initSocket();
    _setupSocketListeners();

    // Cleanup when this provider is disposed
    ref.onDispose(() {
      _socketService.off('broadcast_accepted');
      _socketService.off('broadcast_expired');
      _socketService.off('broadcast_request');
    });

    return _fetchActiveBroadcasts();
  }

  Future<List<BroadcastRequest>> _fetchActiveBroadcasts() async {
    final result = await ref.read(chatRepositoryProvider).getActiveBroadcasts();

    return result.fold(
      (error) {
        debugPrint('Error fetching broadcasts: ${error.message}');
        return [];
      },
      (broadcasts) {
        return broadcasts.data ?? [];
      },
    );
  }

  void _setupSocketListeners() {
    // Listen for broadcast accepted events
    _socketService.on('broadcast_accepted', (data) {
      debugPrint('Broadcast accepted: $data');
      refreshBroadcasts();
    });

    // Listen for broadcast expired events
    _socketService.on('broadcast_expired', (data) {
      debugPrint('Broadcast expired: $data');
      refreshBroadcasts();
    });

    // Listen for broadcast created confirmation
    _socketService.on('broadcast_request', (data) {
      debugPrint('Broadcast request confirmation: $data');
      if (data['success'] == true) {
        refreshBroadcasts();
      }
    });
  }

  Future<void> refreshBroadcasts() async {
    state = const AsyncValue.loading();
    state = AsyncValue.data(await _fetchActiveBroadcasts());
  }

  Future<bool> createBroadcastRequest({
    required String message,
    required String subject,
  }) async {
    try {
      final result =
          await ref.read(chatRepositoryProvider).createBroadcastRequest(
                message: message,
                subject: subject,
              );

      return result.fold(
        (error) {
          debugPrint('Error creating broadcast: ${error.message}');
          if (error.message.contains("created successfully")) {
            refreshBroadcasts();
            return true;
          }
          return false;
        },
        (response) {
          refreshBroadcasts();
          return response.success ?? false;
        },
      );
    } catch (e) {
      debugPrint('Exception creating broadcast: $e');
      return false;
    }
  }

  // Method to send a broadcast request via socket
  Future<bool> sendBroadcastViaSocket({
    required String message,
    required String subject,
  }) async {
    try {
      final requestData = {
        'message': message,
        'subject': subject,
      };

      bool success = false;

      _socketService.emitWithAck('broadcast_request', requestData, (data) {
        debugPrint('Broadcast response: $data');
        success = data['success'] == true;

        if (success) {
          refreshBroadcasts();
        }
      });

      return success;
    } catch (e) {
      debugPrint('Exception sending broadcast via socket: $e');
      return false;
    }
  }
}
