import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

import 'package:prostuti/core/services/nav.dart';

import '../../../../common/widgets/common_widgets/common_widgets.dart';
import '../../enrolled_course_landing/view/enrolled_course_landing_view.dart';
import '../widgets/explore_course_btn.dart';
import '../widgets/my_course_widgets.dart';

class MyCourseView extends ConsumerWidget with CommonWidgets {
  MyCourseView({super.key});

  @override
  Widget build(BuildContext context, ref) {
    double _progress = 0.4;
    return Scaffold(
      appBar: commonAppbar("আমার কোর্স"),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            children: [
              for (int i = 0; i < 3; i++)
                InkWell(
                    onTap: () {
                      Nav().push(EnrolledCourseLandingView());
                    },
                    child: MyCourseCard(progress: _progress)),
              const Gap(16),
              const ExploreCourseBtn()
            ],
          ),
        ),
      ),
    );
  }
}
