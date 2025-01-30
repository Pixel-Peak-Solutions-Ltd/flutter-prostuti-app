import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:prostuti/core/services/nav.dart';
import 'package:prostuti/features/course/course_list/viewmodel/get_course_by_id.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../../common/widgets/common_widgets/common_widgets.dart';
import '../../course_details/view/course_details_view.dart';
import '../viewmodel/course_list_viewmodel.dart';
import '../widgets/category_tile.dart';
import '../widgets/course_card.dart';
import '../widgets/course_list_header.dart';
import '../widgets/search_container.dart';

class CourseListView extends ConsumerStatefulWidget {
  CourseListView({super.key});

  @override
  CourseListViewState createState() => CourseListViewState();
}

class CourseListViewState extends ConsumerState<CourseListView>
    with CommonWidgets {
  List<String> imgPath = [
    'assets/images/fi_2106463.png',
    'assets/images/fi_2134322.png',
    'assets/images/fi_3655592.png',
    'assets/images/fi_6714580.png',
  ];

  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final publishedCourseNotifier = ref.watch(publishedCourseProvider.notifier);
    final publishedCourse = ref.watch(publishedCourseProvider);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: commonAppbar("কোর্সসমূহ"),
      body: Skeletonizer(
        enabled: publishedCourse.isLoading,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
              decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  borderRadius: BorderRadius.circular(16)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Search Container
                  InkWell(
                    onTap: () {},
                    child: SearchContainer(
                      controller: _searchController,
                      onChanged: (query) =>
                          publishedCourseNotifier.filterCourses(query),
                    ),
                  ),
                  const Gap(24),
                  const CourseListHeader(text: 'টেস্ট ক্যাটাগরি'),
                  const Gap(10),
                  // Category List
                  SizedBox(
                    height: 122,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: imgPath.length,
                      itemBuilder: (context, index) {
                        return CategoryTile(
                          imgPath: imgPath,
                          index: index,
                        );
                      },
                    ),
                  ),
                  const Gap(24),
                  const CourseListHeader(text: 'টপ কোর্স লিস্ট'),
                  const Gap(10),

                  for (var course in publishedCourseNotifier.filteredCourses)
                    Column(
                      children: [
                        InkWell(
                          onTap: () {
                            ref
                                .watch(getCourseByIdProvider.notifier)
                                .setId(course.sId!);
                            Nav().push(CourseDetailsView());
                          },
                          child: CourseCard(
                            priceType: course.priceType,
                            title: course.name,
                            price: course.price.toString(),
                            imgPath: course.image!.path ??
                                "assets/images/course_thumbnail.png",
                          ),
                        )
                      ],
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
