import 'package:flutter/material.dart';
import 'package:prostuti/features/chat/model/broadcast_model.dart';
import 'package:prostuti/features/chat/widgets/broadcast_item.dart';
import 'package:skeletonizer/skeletonizer.dart';

class BroadcastSkeletonLoader extends StatelessWidget {
  // Number of skeleton items to show
  final int itemCount;

  const BroadcastSkeletonLoader({
    Key? key,
    this.itemCount = 5,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Create fake broadcast data
    List<BroadcastRequest> fakeBroadcasts = List.generate(
      itemCount,
      (index) => BroadcastRequest(
        id: 'fake_id_$index',
        subject: index % 3 == 0 ? 'Math Help' : 'Physics Question',
        message:
            'This is a placeholder message for the broadcast item. It has enough text to span two lines to properly show the skeleton effect.',
        status: index % 3 == 0
            ? 'accepted'
            : (index % 3 == 1 ? 'pending' : 'declined'),
        createdAt: DateTime.now()
            .subtract(Duration(hours: index * 2))
            .toIso8601String(),
        expiryTime:
            DateTime.now().add(const Duration(hours: 3)).toIso8601String(),
        conversationId: index % 3 == 0 ? 'fake_convo_id' : null,
        acceptedBy: index % 3 == 0 ? 'teacher_id' : null,
      ),
    );

    return Skeletonizer(
      enabled: true,
      effect: const ShimmerEffect(
        baseColor: Color(0xFFE0E0E0),
        highlightColor: Color(0xFFF5F5F5),
      ),
      child: ListView.builder(
        itemCount: itemCount,
        itemBuilder: (context, index) {
          return BroadcastItem(
            broadcast: fakeBroadcasts[index],
            onPressed:
                fakeBroadcasts[index].status == 'accepted' ? () {} : null,
          );
        },
      ),
    );
  }
}

// Single item skeleton for use in different contexts
class SingleBroadcastSkeletonItem extends StatelessWidget {
  final String status;

  const SingleBroadcastSkeletonItem({
    Key? key,
    this.status = 'pending',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final fakeBroadcast = BroadcastRequest(
      id: 'fake_id',
      subject: 'Question',
      message:
          'This is a placeholder message for the broadcast item skeleton. It has enough text to properly show the loading effect.',
      status: status,
      createdAt:
          DateTime.now().subtract(const Duration(hours: 2)).toIso8601String(),
      expiryTime:
          DateTime.now().add(const Duration(hours: 3)).toIso8601String(),
      conversationId: status == 'accepted' ? 'fake_convo_id' : null,
      acceptedBy: status == 'accepted' ? 'teacher_id' : null,
    );

    return Skeletonizer(
      enabled: true,
      child: BroadcastItem(
        broadcast: fakeBroadcast,
        onPressed: status == 'accepted' ? () {} : null,
      ),
    );
  }
}

// Usage example for entire broadcast tab:
// Replace:
// loading: () => const Center(child: CircularProgressIndicator()),
//
// With:
// loading: () => const BroadcastSkeletonLoader(),
