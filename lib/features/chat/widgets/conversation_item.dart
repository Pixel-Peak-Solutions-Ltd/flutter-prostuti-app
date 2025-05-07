import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:prostuti/core/configs/app_colors.dart';
import 'package:prostuti/core/services/localization_service.dart';
import 'package:prostuti/features/chat/model/conversation_model.dart';
import 'package:prostuti/features/chat/viewmodel/chat_viewmodel.dart';

import '../model/chat_model.dart';

class ConversationItem extends ConsumerWidget {
  final Conversation conversation;
  final VoidCallback onTap;

  const ConversationItem({
    Key? key,
    required this.conversation,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Get unread messages
    final unreadMessagesAsync = ref.watch(unreadMessagesNotifierProvider);
    final unreadMessages = unreadMessagesAsync.asData?.value;

    // Check if there are unread messages for this conversation
    final hasUnreadMessages = unreadMessages != null &&
        unreadMessages.conversations != null &&
        unreadMessages.conversations!.any((conv) =>
            conv.id == conversation.conversationId && (conv.count ?? 0) > 0);

    // Check if user is typing in this conversation
    final isTyping = ref
        .watch(typingIndicatorNotifierProvider)
        .containsKey(conversation.conversationId ?? '');

    // Format last message timestamp
    String formattedTime = '';
    if (conversation.lastMessage?.createdAt != null) {
      final messageTime =
          DateTime.tryParse(conversation.lastMessage!.createdAt!);
      if (messageTime != null) {
        final now = DateTime.now();
        if (now.difference(messageTime).inDays == 0) {
          formattedTime = DateFormat.Hm().format(messageTime);
        } else if (now.difference(messageTime).inDays == 1) {
          formattedTime = context.l10n?.yesterday ?? 'Yesterday';
        } else {
          formattedTime = DateFormat.MMMd().format(messageTime);
        }
      }
    }

    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: hasUnreadMessages
              ? Theme.of(context).brightness == Brightness.dark
                  ? AppColors.backgroundTertiaryDark.withOpacity(0.2)
                  : AppColors.shadePrimaryLight.withOpacity(0.2)
              : Colors.transparent,
          border: Border(
            bottom: BorderSide(
              color: Theme.of(context).dividerColor,
              width: 0.5,
            ),
          ),
        ),
        child: Row(
          children: [
            // Avatar
            CircleAvatar(
              radius: 24,
              backgroundImage: const AssetImage('assets/images/test_dp.jpg'),
              child: hasUnreadMessages
                  ? Align(
                      alignment: Alignment.topRight,
                      child: Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          color: AppColors.backgroundActionPrimaryLight,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Theme.of(context).scaffoldBackgroundColor,
                            width: 2,
                          ),
                        ),
                      ),
                    )
                  : null,
            ),
            const SizedBox(width: 16),

            // Conversation details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Participant name
                      Expanded(
                        child: Text(
                          conversation.participant?.name ??
                              context.l10n?.onlineStatus ??
                              'Unknown',
                          style: TextStyle(
                            fontWeight: hasUnreadMessages
                                ? FontWeight.bold
                                : FontWeight.normal,
                            fontSize: 16,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),

                      // Time
                      if (formattedTime.isNotEmpty)
                        Text(
                          formattedTime,
                          style: TextStyle(
                            color: hasUnreadMessages
                                ? AppColors.textActionSecondaryLight
                                : Theme.of(context).textTheme.bodySmall?.color,
                            fontSize: 12,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 4),

                  // Last message or typing indicator
                  Row(
                    children: [
                      Expanded(
                        child: isTyping
                            ? Text(
                                context.l10n?.typing ?? 'typing...',
                                style: TextStyle(
                                  color: AppColors.textActionSecondaryLight,
                                  fontSize: 14,
                                  fontStyle: FontStyle.italic,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              )
                            : Text(
                                conversation.lastMessage?.message ??
                                    conversation.message ??
                                    context.l10n?.noMessagesYet ??
                                    'No messages yet',
                                style: TextStyle(
                                  color: hasUnreadMessages
                                      ? Theme.of(context)
                                          .textTheme
                                          .bodyLarge
                                          ?.color
                                      : Theme.of(context)
                                          .textTheme
                                          .bodySmall
                                          ?.color,
                                  fontSize: 14,
                                  fontWeight: hasUnreadMessages
                                      ? FontWeight.w600
                                      : FontWeight.normal,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                      ),

                      // Unread message count badge
                      if (hasUnreadMessages)
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppColors.backgroundActionPrimaryLight,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            unreadMessages!.conversations!
                                .firstWhere(
                                  (conv) =>
                                      conv.id == conversation.conversationId,
                                  orElse: () =>
                                      ConversationUnreadCount(count: 0),
                                )
                                .count
                                .toString(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
