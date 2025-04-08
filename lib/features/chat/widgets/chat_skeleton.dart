import 'package:flutter/material.dart';
import 'package:prostuti/features/chat/model/chat_model.dart';
import 'package:prostuti/features/chat/widgets/chat_message_item.dart';
import 'package:skeletonizer/skeletonizer.dart';

class SkeletonizedChatScreen extends StatelessWidget {
  const SkeletonizedChatScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Generate fake messages with varying lengths and times
    final fakeMessages = [
      ChatMessage(
        id: 'msg1',
        conversationId: 'conv1',
        senderId: 'user1',
        recipientId: 'current_user',
        message: 'Hi there! How are you doing today?',
        createdAt: DateTime.now()
            .subtract(const Duration(minutes: 35))
            .toIso8601String(),
        read: true,
        senderRole: 'teacher',
      ),
      ChatMessage(
        id: 'msg2',
        conversationId: 'conv1',
        senderId: 'current_user',
        recipientId: 'user1',
        message:
            'I\'m doing great! Just working on the Flutter project we discussed yesterday.',
        createdAt: DateTime.now()
            .subtract(const Duration(minutes: 33))
            .toIso8601String(),
        read: true,
        senderRole: 'student',
      ),
      ChatMessage(
        id: 'msg3',
        conversationId: 'conv1',
        senderId: 'user1',
        recipientId: 'current_user',
        message:
            'That sounds fantastic! How is it coming along? Do you need any help with the implementation?',
        createdAt: DateTime.now()
            .subtract(const Duration(minutes: 30))
            .toIso8601String(),
        read: true,
        senderRole: 'teacher',
      ),
      ChatMessage(
        id: 'msg4',
        conversationId: 'conv1',
        senderId: 'current_user',
        recipientId: 'user1',
        message:
            'I\'m making good progress. Just struggling with some state management concepts.',
        createdAt: DateTime.now()
            .subtract(const Duration(minutes: 25))
            .toIso8601String(),
        read: true,
        senderRole: 'student',
      ),
      ChatMessage(
        id: 'msg5',
        conversationId: 'conv1',
        senderId: 'user1',
        recipientId: 'current_user',
        message:
            'State management can be tricky. Have you tried using Riverpod? It works well with Flutter.',
        createdAt: DateTime.now()
            .subtract(const Duration(minutes: 20))
            .toIso8601String(),
        read: true,
        senderRole: 'teacher',
      ),
      ChatMessage(
        id: 'msg6',
        conversationId: 'conv1',
        senderId: 'current_user',
        recipientId: 'user1',
        message:
            'Yes, I\'m actually using Riverpod! It\'s just taking some time to get used to the providers and notifiers.',
        createdAt: DateTime.now()
            .subtract(const Duration(minutes: 15))
            .toIso8601String(),
        read: true,
        senderRole: 'student',
      ),
      ChatMessage(
        id: 'msg7',
        conversationId: 'conv1',
        senderId: 'user1',
        recipientId: 'current_user',
        message:
            'I can share some resources that helped me. Also, would you like to schedule a quick call to discuss your specific issues?',
        createdAt: DateTime.now()
            .subtract(const Duration(minutes: 5))
            .toIso8601String(),
        read: false,
        senderRole: 'teacher',
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        toolbarHeight: 40,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: Skeletonizer(
          enabled: true,
          child: Row(
            children: [
              const CircleAvatar(
                radius: 16,
                backgroundImage: AssetImage('assets/images/test_dp.jpg'),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Sarah Johnson',
                    style: TextStyle(fontSize: 16),
                  ),
                  Text(
                    'online',
                    style: const TextStyle(
                      fontSize: 12,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      body: Column(
        children: [
          // Messages list with skeleton effect
          Expanded(
            child: Skeletonizer(
              enabled: true,
              effect: const ShimmerEffect(
                baseColor: Color(0xFFE0E0E0),
                highlightColor: Color(0xFFF5F5F5),
              ),
              child: ListView.builder(
                reverse: true,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                itemCount: fakeMessages.length,
                itemBuilder: (context, index) {
                  final message = fakeMessages[index];
                  final isMe = message.senderId == 'current_user' ||
                      message.senderRole == 'student';
                  final isLastMessage = index == 0;

                  return ChatMessageItem(
                    message: message,
                    isMe: isMe,
                    isLastMessage: isLastMessage,
                  );
                },
              ),
            ),
          ),

          // Input field with skeleton effect
          Skeletonizer(
            enabled: true,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 1,
                    offset: const Offset(0, -1),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              'Type a message...',
                              style: TextStyle(
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ),
                          Icon(
                            Icons.emoji_emotions_outlined,
                            color: Colors.grey.shade600,
                          ),
                          const SizedBox(width: 8),
                          Icon(
                            Icons.attach_file,
                            color: Colors.grey.shade600,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  CircleAvatar(
                    backgroundColor: Theme.of(context).primaryColor,
                    child: const Icon(
                      Icons.send,
                      color: Colors.white,
                      size: 18,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// How to use this:
// 1. Add this file to your project
// 2. When showing loading state, display this screen instead of CircularProgressIndicator
//
// Example usage in your code:
// return messagesAsync.when(
//   data: (messages) => YourRegularChatView(messages),
//   loading: () => const SkeletonizedChatScreen(),
//   error: (error, stack) => ErrorView(error),
// );
