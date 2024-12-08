import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:prostuti/common/widgets/common_widgets/common_widgets.dart';
import 'package:pod_player/pod_player.dart';
import 'package:prostuti/features/course/materials/record_class/viewmodel/record_class_details_viewmodel.dart';
import 'package:prostuti/features/course/materials/record_class/widgets/record_class_skeleton.dart';

class RecordClassDetailsView extends ConsumerStatefulWidget {
  final String videoUrl;

  const RecordClassDetailsView({super.key, required this.videoUrl});

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
    final recordClassAsync = ref.watch(recordClassDetailsViewmodelProvider);

    return Scaffold(
      appBar: commonAppbar("রেকর্ড ক্লাস"),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: recordClassAsync.when(
          data: (data) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                PodVideoPlayer(controller: _controller),
                const Gap(16),
                Text(
                  data.data!.recodeClassName ?? "No Name",
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const Gap(24),
                Text(
                  "রেকর্ড সম্পর্কে",
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const Gap(8),
                Text(
                  data.data!.classDetails ?? "No Details",
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ],
            );
          },
          error: (error, stackTrace) {
            return Text('$error');
          },
          loading: () => const RecordClassSkeleton(),
        ),
      ),
    );
  }
}
