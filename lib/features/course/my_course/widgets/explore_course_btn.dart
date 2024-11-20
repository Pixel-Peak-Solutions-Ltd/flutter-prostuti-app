import 'package:flutter/material.dart';
import 'package:prostuti/core/configs/app_colors.dart';
import 'package:prostuti/core/services/nav.dart';

import '../../course_list/view/course_list_view.dart';

class ExploreCourseBtn extends StatelessWidget {
  const ExploreCourseBtn({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        minimumSize: Size(MediaQuery.sizeOf(context).width, 54),
        backgroundColor: const Color(0xffD1E0FF),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
            side: const BorderSide(color: Color(0xff155EEF))),
      ),
      onPressed: () => Nav().push(const CourseListView()),
      child: Text(
        'এক্সপলোর টেস্ট কোর্স',
        style: Theme.of(context).textTheme.titleSmall!.copyWith(
              color: AppColors.textActionSecondaryLight,
              fontWeight: FontWeight.w900,
            ),
      ),
    );
  }
}
