import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prostuti/common/widgets/common_widgets/common_widgets.dart';
import 'package:prostuti/features/course/materials/resources/view/resource_details_view.dart';
import 'package:prostuti/features/course/materials/resources/viewmodel/get_resource_by_id.dart';
import 'package:prostuti/features/course/materials/resources/viewmodel/resources_viewmodel.dart';

import '../../../../../core/services/nav.dart';
import '../../../course_list/viewmodel/get_course_by_id.dart';
import '../../get_material_completion.dart';
import '../../shared/widgets/material_list_skeleton.dart';
import '../../shared/widgets/trailing_icon.dart';

class ResourcesView extends ConsumerStatefulWidget {
  const ResourcesView({super.key});

  @override
  ResourcesViewState createState() => ResourcesViewState();
}

class ResourcesViewState extends ConsumerState<ResourcesView>
    with CommonWidgets {
  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    final resourceListAsync = ref.watch(resourceViewmodelProvider);
    final courseId = ref.read(getCourseByIdProvider);
    final completedAsync = ref.watch(completedIdProvider(courseId));

    return Scaffold(
      appBar: commonAppbar("রিসোর্স"),
      body: resourceListAsync.when(
        data: (resource) {
          return completedAsync.when(
            data: (completedId) {
              final completedSet = Set<String>.from(completedId);
              return ListView.builder(
                itemCount: resource.length,
                itemBuilder: (context, index) {
                  final isCompleted =
                      completedSet.contains(resource[index].sId);

                  return InkWell(
                    onTap: () {
                      DateTime parsedDate =
                          DateTime.parse(resource[index].resourceDate!);
                      DateTime now = DateTime.now();
                      if ((parsedDate.day == now.day &&
                              parsedDate.month == now.month &&
                              parsedDate.year == now.year) ||
                          (parsedDate.isBefore(now))) {
                        ref
                            .watch(getResourceByIdProvider.notifier)
                            .setResourceId(resource[index].sId!);
                        Nav().push(ResourceDetailsView(
                          isCompleted: isCompleted,
                        ));
                      }
                    },
                    child: lessonItem(theme,
                        trailingIcon: TrailingIcon(
                          classDate: resource[index].resourceDate!,
                          isCompleted: isCompleted,
                        ),
                        itemName: "${resource[index].name}",
                        icon: Icons.video_collection_rounded,
                        lessonName: '${resource[index].lessonId!.number} '),
                  );
                },
              );
            },
            error: (error, stackTrace) => const Icon(
              Icons.dangerous,
              color: Colors.red,
            ),
            loading: () => MaterialListSkeleton(),
          );
        },
        error: (error, stackTrace) {
          return Text("$error");
        },
        loading: () {
          return MaterialListSkeleton();
        },
      ),
    );
  }
}
