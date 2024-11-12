import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:prostuti/common/widgets/appbar/common_app_bar.dart';
import 'package:prostuti/features/my_course/widgets/explore_course_btn.dart';

import '../widgets/my_course_widgets.dart';

class MyCourseView extends ConsumerWidget {
  const MyCourseView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    double _progress = 0.4;
    return Scaffold(
      appBar: commonAppbar("আমার কোর্স", context),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            children: [
              for (int i = 0; i < 3; i++) MyCourseCard(progress: _progress),
              const Gap(16),
              const ExploreCourseBtn()
            ],
          ),
        ),
      ),
    );
  }
}
