import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prostuti/common/widgets/common_widgets/common_widgets.dart';
import 'package:prostuti/core/services/localization_service.dart';
import 'package:prostuti/features/course/course_details/viewmodel/course_details_vm.dart';
import 'package:prostuti/features/course/course_details/widgets/course_details_skeleton.dart';

import 'routine_view.dart';

class CourseRoutineView extends ConsumerWidget with CommonWidgets {
  CourseRoutineView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final courseDetailsAsync = ref.watch(courseDetailsViewmodelProvider);

    return Scaffold(
      appBar: commonAppbar(context.l10n?.routine ?? 'Routine'),
      body: courseDetailsAsync.when(
        data: (_) => const RoutineView(),
        loading: () => const CourseDetailsSkeleton(),
        error: (error, stackTrace) => Center(
          child: Text("${context.l10n?.error}: $error"),
        ),
      ),
    );
  }
}
