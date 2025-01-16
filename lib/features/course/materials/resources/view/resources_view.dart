import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prostuti/common/widgets/common_widgets/common_widgets.dart';
import 'package:prostuti/features/course/materials/resources/view/resource_details_view.dart';
import 'package:prostuti/features/course/materials/resources/viewmodel/get_resource_by_id.dart';

import '../../../course_details/viewmodel/course_details_vm.dart';
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
    final courseDetailsAsync = ref.watch(courseDetailsViewmodelProvider);
    final courseId = ref.read(getCourseByIdProvider);
    final completedAsync = ref.watch(completedIdProvider(courseId));

    return Scaffold(
      appBar: commonAppbar("রিসোর্স"),
      body: courseDetailsAsync.when(
        data: (courseDetails) {
          return completedAsync.when(
            data: (completedId) {
              final completedSet = Set<String>.from(completedId);
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 24, horizontal: 16),
                    decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary,
                        borderRadius: BorderRadius.circular(16)),
                    child: Column(
                      children: [
                        for (int i = 0;
                            i < (courseDetails.data!.lessons!.length);
                            i++)
                          if (courseDetails.data!.lessons!.isNotEmpty)
                            ListTileTheme(
                              contentPadding: const EdgeInsets.all(0),
                              dense: true,
                              horizontalTitleGap: 0.0,
                              minLeadingWidth: 0,
                              child: ExpansionTile(
                                title: lessonName(theme,
                                    '${courseDetails.data!.lessons![i].name} ${i + 1} '),
                                children: [
                                  for (int j = 0;
                                      j <
                                          courseDetails.data!.lessons![i]
                                              .resources!.length;
                                      j++)
                                    InkWell(
                                      onTap: () {
                                        DateTime parsedDate = DateTime.parse(
                                            courseDetails.data!.lessons![i]
                                                .resources![j].resourceDate!);
                                        DateTime now = DateTime.now();
                                        if ((parsedDate.day == now.day &&
                                                parsedDate.month == now.month &&
                                                parsedDate.year == now.year) ||
                                            (parsedDate.isBefore(now))) {
                                          ref
                                              .watch(getResourceByIdProvider
                                                  .notifier)
                                              .setResourceId(courseDetails
                                                  .data!
                                                  .lessons![i]
                                                  .resources![j]
                                                  .sId!);

                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    ResourceDetailsView(
                                                      isCompleted:
                                                          completedSet.contains(
                                                              courseDetails
                                                                  .data!
                                                                  .lessons![i]
                                                                  .resources![j]
                                                                  .sId),
                                                    )),
                                          ).then((value) {
                                            if (value ?? false) {
                                              ref.refresh(completedIdProvider(
                                                  courseId));
                                            }
                                          });
                                        }
                                      },
                                      child: materialItem(
                                        theme,
                                        trailingIcon: TrailingIcon(
                                          classDate: courseDetails
                                              .data!
                                              .lessons![i]
                                              .resources![j]
                                              .resourceDate!,
                                          isCompleted: completedSet.contains(
                                              courseDetails.data!.lessons![i]
                                                  .resources![j].sId),
                                        ),
                                        itemName:
                                            "${courseDetails.data!.lessons![i].resources![j].name}",
                                        icon: "assets/icons/resource.svg",
                                      ),
                                    ),
                                ],
                              ),
                            ),
                      ],
                    )),
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
