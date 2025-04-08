import 'package:dartz/dartz.dart';
import 'package:prostuti/core/services/dio_service.dart';
import 'package:prostuti/core/services/error_response.dart';
import 'package:prostuti/features/chat/model/broadcast_model.dart';
import 'package:prostuti/features/chat/model/conversation_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../model/chat_model.dart';

part 'chat_repo.g.dart';

@riverpod
ChatRepository chatRepository(ChatRepositoryRef ref) {
  final dioService = ref.watch(dioServiceProvider);
  return ChatRepository(dioService);
}

class ChatRepository {
  final DioService _dioService;

  ChatRepository(this._dioService);

  // Create a broadcast request (Student only)
  Future<Either<ErrorResponse, BroadcastResponse>> createBroadcastRequest({
    required String message,
    required String subject,
  }) async {
    try {
      final response = await _dioService.postRequest(
        '/chat/broadcast',
        {
          'message': message,
          'subject': subject,
        },
      );

      print('Status code: ${response.statusCode}');
      print('Response data: ${response.data}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        return Right(BroadcastResponse.fromJson(response.data));
      } else {
        return Left(ErrorResponse.fromJson(response.data));
      }
    } catch (e) {
      return Left(ErrorResponse(
        success: false,
        message: 'Failed to create broadcast request: $e',
      ));
    }
  }

  // Get active broadcasts (Student only)
  Future<Either<ErrorResponse, BroadcastResponse>> getActiveBroadcasts() async {
    try {
      final response = await _dioService.getRequest('/chat/broadcasts/active');

      if (response.statusCode == 200) {
        return Right(BroadcastResponse.fromJson(response.data));
      } else {
        return Left(ErrorResponse.fromJson(response.data));
      }
    } catch (e) {
      return Left(ErrorResponse(
        success: false,
        message: 'Failed to get active broadcasts: $e',
      ));
    }
  }

  // Get active conversations (Both roles)
  Future<Either<ErrorResponse, ConversationsResponse>>
      getActiveConversations() async {
    try {
      final response = await _dioService.getRequest('/chat/conversations');

      if (response.statusCode == 200) {
        return Right(ConversationsResponse.fromJson(response.data));
      } else {
        return Left(ErrorResponse.fromJson(response.data));
      }
    } catch (e) {
      return Left(ErrorResponse(
        success: false,
        message: 'Failed to get active conversations: $e',
      ));
    }
  }

  // Get chat history (Both roles)
  Future<Either<ErrorResponse, ChatMessagesResponse>> getChatHistory({
    required String conversationId,
    int page = 1,
    int limit = 20,
  }) async {
    try {
      final response = await _dioService.getRequest(
        '/chat/messages',
        queryParameters: {
          'conversation_id': conversationId,
          'page': page,
          'limit': limit,
        },
      );

      if (response.statusCode == 200) {
        return Right(ChatMessagesResponse.fromJson(response.data));
      } else {
        return Left(ErrorResponse.fromJson(response.data));
      }
    } catch (e) {
      return Left(ErrorResponse(
        success: false,
        message: 'Failed to get chat history: $e',
      ));
    }
  }

  // Mark messages as read (Both roles)
  Future<Either<ErrorResponse, Map<String, dynamic>>> markMessagesAsRead(
      String conversationId) async {
    try {
      final response = await _dioService.postRequest(
        '/chat/messages/$conversationId/read',
        {},
      );

      if (response.statusCode == 200) {
        return Right(response.data);
      } else {
        return Left(ErrorResponse.fromJson(response.data));
      }
    } catch (e) {
      return Left(ErrorResponse(
        success: false,
        message: 'Failed to mark messages as read: $e',
      ));
    }
  }

  // Get unread message count (Both roles)
  Future<Either<ErrorResponse, UnreadCountResponse>>
      getUnreadMessageCount() async {
    try {
      final response = await _dioService.getRequest('/chat/messages/unread');

      if (response.statusCode == 200) {
        return Right(UnreadCountResponse.fromJson(response.data));
      } else {
        return Left(ErrorResponse.fromJson(response.data));
      }
    } catch (e) {
      return Left(ErrorResponse(
        success: false,
        message: 'Failed to get unread message count: $e',
      ));
    }
  }
}
