import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:prostuti/common/widgets/common_widgets/common_widgets.dart';
import 'package:pod_player/pod_player.dart';

class RecordClassDetailsView extends ConsumerStatefulWidget {
  final String title;

  const RecordClassDetailsView({super.key, required this.title});

  @override
  RecordClassDetailsViewState createState() => RecordClassDetailsViewState();
}

class RecordClassDetailsViewState extends ConsumerState<RecordClassDetailsView>
    with CommonWidgets {
  late final PodPlayerController _controller;

  @override
  void initState() {
    _controller = PodPlayerController(
      playVideoFrom: PlayVideoFrom.network(
        'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerFun.mp4',
      ),
    )..initialise();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: commonAppbar("রেকর্ড ক্লাস"),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            PodVideoPlayer(controller: _controller),
            Gap(16),
            Text(
              widget.title,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            Gap(24),
            Text(
              "রেকর্ড সম্পর্কে",
              style: Theme.of(context).textTheme.titleMedium,
            ),
            Gap(8),
            Text(
              'জীবের মধ্যে সবচেয়ে সম্পূর্ণতা মানুষের। কিন্তু সবচেয়ে অসম্পূর্ণ হয়ে সে জন্মগ্রহণ করে। বাঘ ভালুক তার জীবনযাত্রার পনেরো- আনা মূলধন নিয়ে আসে প্রকৃতির মালখানা থেকে। জীবরঙ্গভূমিতে মানুষ এসে দেখা দেয় দুই শূন্য হাতে মুঠো বেঁধে মহাকায় জন্তু ছিল প্রকাণ্ড ... আরো দেখুন',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ],
        ),
      ),
    );
  }
}
