import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:prostuti/core/services/localization_service.dart';

import '../model/chat_model.dart';

class ChatMessageItem extends StatelessWidget {
  final ChatMessage message;
  final bool isMe;
  final bool isLastMessage;

  const ChatMessageItem({
    Key? key,
    required this.message,
    required this.isMe,
    this.isLastMessage = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final messageTime = DateTime.tryParse(message.createdAt ?? '');
    final formattedTime = messageTime != null
        ? DateFormat.Hm().format(messageTime)
        : context.l10n?.justNow ?? 'Just now';

    // Determine how long ago the message was sent for readable timestamp
    String timeAgo = '';
    if (messageTime != null) {
      final now = DateTime.now();
      final difference = now.difference(messageTime);

      if (difference.inMinutes < 1) {
        timeAgo = context.l10n?.justNow ?? 'Just now';
      } else if (difference.inHours < 1) {
        timeAgo = '${difference.inMinutes}m ago';
      } else if (difference.inDays < 1) {
        timeAgo = '${difference.inHours}h ago';
      } else if (difference.inDays < 7) {
        timeAgo = '${difference.inDays}d ago';
      } else {
        timeAgo = DateFormat.MMMd().format(messageTime);
      }
    }

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment:
            isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isMe) ...[
            const CircleAvatar(
              radius: 16,
              backgroundImage: AssetImage('assets/images/test_dp.jpg'),
            ),
            const SizedBox(width: 8),
          ],

          // Message content
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: isMe
                    ? Theme.of(context).colorScheme.secondary
                    : Theme.of(context).colorScheme.primary,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(16),
                  topRight: const Radius.circular(16),
                  bottomLeft: isMe
                      ? const Radius.circular(16)
                      : const Radius.circular(4),
                  bottomRight: isMe
                      ? const Radius.circular(4)
                      : const Radius.circular(16),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    message.message ?? '',
                    style: TextStyle(
                      color: isMe
                          ? Colors.white
                          : Theme.of(context).textTheme.bodyLarge?.color,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        timeAgo,
                        style: TextStyle(
                          color: isMe ? Colors.white70 : Colors.grey,
                          fontSize: 10,
                        ),
                      ),
                      if (isMe) ...[
                        const SizedBox(width: 4),
                        Icon(
                          message.read ?? false ? Icons.done_all : Icons.done,
                          color: message.read ?? false
                              ? Colors.white
                              : Colors.white70,
                          size: 14,
                        ),
                        if (message.read ?? false)
                          const Text(
                            ' Read',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 10,
                            ),
                          ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ),

          if (isMe) ...[
            const SizedBox(width: 8),
            const CircleAvatar(
              radius: 16,
              backgroundImage: AssetImage('assets/images/test_dp.jpg'),
            ),
          ],
        ],
      ),
    );
  }
}
