import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:prostuti/core/configs/app_colors.dart';
import 'package:prostuti/core/services/localization_service.dart';
import 'package:prostuti/features/chat/model/broadcast_model.dart';

class BroadcastItem extends StatelessWidget {
  final BroadcastRequest broadcast;
  final VoidCallback? onPressed;

  const BroadcastItem({
    Key? key,
    required this.broadcast,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Format created time
    String formattedTime = '';
    if (broadcast.createdAt != null) {
      final createdTime = DateTime.tryParse(broadcast.createdAt!);
      if (createdTime != null) {
        final now = DateTime.now();
        if (now.difference(createdTime).inHours < 24) {
          formattedTime = DateFormat.Hm().format(createdTime);
        } else {
          formattedTime = DateFormat.MMMd().format(createdTime);
        }
      }
    }

    // Calculate time until expiry
    String expiryText = '';
    bool isExpired = false;
    if (broadcast.expiryTime != null) {
      final expiryTime = DateTime.tryParse(broadcast.expiryTime!);
      if (expiryTime != null) {
        final now = DateTime.now();
        final difference = expiryTime.difference(now);

        if (difference.isNegative) {
          expiryText = context.l10n?.broadcastExpired ?? 'Expired';
          isExpired = true;
        } else if (difference.inHours > 0) {
          expiryText = '${difference.inHours}h ${difference.inMinutes % 60}m';
        } else {
          expiryText = '${difference.inMinutes}m';
        }
      }
    }

    // Status color and text
    Color statusColor;
    String statusText = broadcast.status ?? 'pending';

    switch (broadcast.status) {
      case 'pending':
        statusColor = isExpired ? Colors.grey : Colors.orange;
        statusText = isExpired ? 'expired' : 'pending';
        break;
      case 'accepted':
        statusColor = Colors.green;
        break;
      case 'declined':
        statusColor = Colors.red;
        break;
      case 'expired':
        statusColor = Colors.grey;
        break;
      default:
        statusColor = Colors.orange;
    }

    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: (isExpired || broadcast.status == 'declined') ? null : onPressed,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Subject and status
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.shadePrimaryLight,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      broadcast.subject ?? context.l10n?.subject ?? 'Subject',
                      style: const TextStyle(
                        color: AppColors.textActionSecondaryLight,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: statusColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: statusColor,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          statusText,
                          style: TextStyle(
                            color: statusColor,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // Message content
              Text(
                broadcast.message ?? '',
                style: Theme.of(context).textTheme.bodyLarge,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),

              const SizedBox(height: 12),

              // Footer with time and expiry
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.access_time,
                        size: 16,
                        color: Colors.grey,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        formattedTime,
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  if (expiryText.isNotEmpty &&
                      (broadcast.status == 'pending' || isExpired))
                    Row(
                      children: [
                        Icon(
                          isExpired ? Icons.timer_off : Icons.timer_outlined,
                          size: 16,
                          color: isExpired ? Colors.red : Colors.grey,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          expiryText,
                          style: TextStyle(
                            color: isExpired ? Colors.red : Colors.grey,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  if (broadcast.status == 'accepted')
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.green.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.message,
                            size: 16,
                            color: Colors.green,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            context.l10n?.openChat ?? 'Open chat',
                            style: const TextStyle(
                              color: Colors.green,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
