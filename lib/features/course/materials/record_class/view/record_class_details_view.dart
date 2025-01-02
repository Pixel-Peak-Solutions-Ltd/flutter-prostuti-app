import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:pod_player/pod_player.dart';
import 'package:prostuti/common/widgets/common_widgets/common_widgets.dart';
import 'package:prostuti/features/course/enrolled_course_landing/repository/enrolled_course_landing_repo.dart';
import 'package:prostuti/features/course/materials/record_class/view/record_class_view.dart';
import 'package:prostuti/features/course/materials/record_class/viewmodel/change_btn_state.dart';
import 'package:prostuti/features/course/materials/record_class/viewmodel/record_class_details_viewmodel.dart';
import 'package:prostuti/features/course/materials/record_class/widgets/record_class_skeleton.dart';

import '../../../../../core/services/debouncer.dart';
import '../../../../../core/services/nav.dart';
import '../../../../../core/services/size_config.dart';
import '../viewmodel/get_record_class_id.dart';

class RecordClassDetailsView extends ConsumerStatefulWidget {
  final String videoUrl;
  final bool isCompleted;

  const RecordClassDetailsView(
      {super.key, required this.videoUrl, required this.isCompleted});

  @override
  RecordClassDetailsViewState createState() => RecordClassDetailsViewState();
}

class RecordClassDetailsViewState extends ConsumerState<RecordClassDetailsView>
    with CommonWidgets {
  late final PodPlayerController _controller;
  final _debouncer = Debouncer(milliseconds: 120);
  final _loadingProvider = StateProvider<bool>((ref) => false);

  @override
  void initState() {
    _controller = PodPlayerController(
      playVideoFrom: PlayVideoFrom.network(
        widget.videoUrl,
      ),
    )..initialise();
    super.initState();
  }

  @override
  void dispose() {
    _controller.pause();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final recordClassAsync = ref.watch(recordClassDetailsViewmodelProvider);

    final isLoading = ref.watch(_loadingProvider);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: commonAppbar("রেকর্ড ক্লাস"),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: recordClassAsync.when(
          data: (data) {
            return SingleChildScrollView(
              child: Column(
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
                  const Gap(32),
                  isLoading
                      ? const CircularProgressIndicator()
                      : ElevatedButton(
                          onPressed: ref.watch(changeBtnStateProvider) ||
                                  widget.isCompleted
                              ? () {}
                              : () {
                                  _debouncer.run(
                                      action: () async {
                                        final response = await ref
                                            .read(
                                                enrolledCourseLandingRepoProvider)
                                            .markAsComplete({
                                          "materialType": "record",
                                          "material_id":
                                              ref.read(getRecordClassIdProvider)
                                        });

                                        if (response) {
                                          ref
                                              .watch(changeBtnStateProvider
                                                  .notifier)
                                              .setBtnState();

                                          Nav().pushReplacement(
                                              const RecordClassView());
                                        }
                                      },
                                      loadingController:
                                          ref.read(_loadingProvider.notifier));
                                },
                          style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(4)),
                              backgroundColor: const Color(0xff2970FF),
                              fixedSize:
                                  Size(SizeConfig.w(356), SizeConfig.h(54))),
                          child: Text(
                            ref.watch(changeBtnStateProvider) ||
                                    widget.isCompleted
                                ? "সম্পন্ন হয়েছে"
                                : 'কোর্স সম্পন্ন করুন',
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium!
                                .copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w800),
                          ),
                        ),
                ],
              ),
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
