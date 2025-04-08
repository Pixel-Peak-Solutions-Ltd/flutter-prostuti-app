import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prostuti/common/widgets/common_widgets/common_widgets.dart';
import 'package:prostuti/core/services/localization_service.dart';
import 'package:prostuti/features/chat/viewmodel/chat_viewmodel.dart';
import 'package:prostuti/features/chat/widgets/chat_input_field.dart';
import 'package:prostuti/features/chat/widgets/chat_message_item.dart';

import '../widgets/chat_skeleton.dart';

class ChatMessageView extends ConsumerStatefulWidget {
  final String conversationId;
  final String recipientId;
  final String recipientName;

  const ChatMessageView({
    super.key,
    required this.conversationId,
    required this.recipientId,
    required this.recipientName,
  });

  @override
  ConsumerState<ChatMessageView> createState() => _ChatMessageViewState();
}

class _ChatMessageViewState extends ConsumerState<ChatMessageView>
    with CommonWidgets {
  final ScrollController _scrollController = ScrollController();
  late String userId;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);

    // Get current user ID from profile or auth provider
    // For now, we'll just assume it's retrieved already
    userId = 'current_user_id';
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent * 0.9) {
      // Load more messages when scrolling to the top (newer messages are at the bottom)
      ref
          .read(
            chatMessagesNotifierProvider(widget.conversationId).notifier,
          )
          .loadMoreMessages(widget.conversationId);
    }
  }

  void _sendMessage(String message) {
    ref
        .read(
          chatMessagesNotifierProvider(widget.conversationId).notifier,
        )
        .sendMessage(
          conversationId: widget.conversationId,
          recipientId: widget.recipientId,
          message: message,
        );

    // Scroll to the bottom to see the new message
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          0.0,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final messagesAsync = ref.watch(
      chatMessagesNotifierProvider(widget.conversationId),
    );

    // Watching for typing indicators
    final isTyping =
        ref.watch(typingUsersProvider).containsKey(widget.conversationId);

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        toolbarHeight: 40,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: Row(
          children: [
            const CircleAvatar(
              radius: 16,
              backgroundImage: AssetImage('assets/images/test_dp.jpg'),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.recipientName,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                if (isTyping)
                  Text(
                    context.l10n?.typing ?? 'typing...',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
              ],
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          // Messages list
          Expanded(
            child: messagesAsync.when(
              data: (messages) {
                // Sort messages by time (newest first for reverse list)
                messages.sort((a, b) {
                  final timeA = DateTime.tryParse(a.createdAt ?? '');
                  final timeB = DateTime.tryParse(b.createdAt ?? '');
                  if (timeA == null || timeB == null) return 0;
                  return timeB.compareTo(timeA);
                });

                if (messages.isEmpty) {
                  return Center(
                    child: Text(
                      context.l10n?.noMessagesYet ?? 'No messages yet',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  );
                }

                return ListView.builder(
                  controller: _scrollController,
                  reverse: true,
                  // Display newest messages at the bottom
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  itemCount: messages.length + (isTyping ? 1 : 0),
                  itemBuilder: (context, index) {
                    // Add typing indicator at the top
                    if (isTyping && index == 0) {
                      return Padding(
                        padding: const EdgeInsets.only(
                          left: 16,
                          right: 16,
                          top: 8,
                          bottom: 16,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            const CircleAvatar(
                              radius: 16,
                              backgroundImage:
                                  AssetImage('assets/images/test_dp.jpg'),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 12,
                              ),
                              decoration: BoxDecoration(
                                color: Theme.of(context).brightness ==
                                        Brightness.dark
                                    ? Colors.grey[800]
                                    : Colors.grey[200],
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    width: 8,
                                    height: 8,
                                    decoration: BoxDecoration(
                                      color: Colors.grey[500],
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  Container(
                                    width: 8,
                                    height: 8,
                                    decoration: BoxDecoration(
                                      color: Colors.grey[500],
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  Container(
                                    width: 8,
                                    height: 8,
                                    decoration: BoxDecoration(
                                      color: Colors.grey[500],
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    }

                    final adjustedIndex = isTyping ? index - 1 : index;
                    final message = messages[adjustedIndex];
                    final isMe = message.senderId == userId ||
                        message.senderRole == 'student';
                    final isLastMessage = adjustedIndex == 0;

                    return ChatMessageItem(
                      message: message,
                      isMe: isMe,
                      isLastMessage: isLastMessage,
                    );
                  },
                );
              },
              loading: () => const SkeletonizedChatScreen(),
              error: (error, stack) => Center(
                child: Text('${context.l10n?.error ?? 'Error'}: $error'),
              ),
            ),
          ),

          // Input field
          ChatInputField(
            conversationId: widget.conversationId,
            recipientId: widget.recipientId,
            onSendMessage: _sendMessage,
          ),
        ],
      ),
    );
  }
}
