import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:prostuti/common/widgets/appbar/common_app_bar.dart';
import 'package:prostuti/core/services/nav.dart';
import 'package:prostuti/features/course_details/view/course_details_view.dart';
import 'package:prostuti/features/course_list/widgets/category_tile.dart';
import 'package:prostuti/features/course_list/widgets/course_card.dart';
import 'package:prostuti/features/course_list/view/course_list_header.dart';
import 'package:prostuti/features/course_list/widgets/search_container.dart';

import '../model/CourseCardEntity.dart';

class CourseListView extends ConsumerStatefulWidget {
  const CourseListView({Key? key}) : super(key: key);

  @override
  CourseListViewState createState() => CourseListViewState();
}

class CourseListViewState extends ConsumerState<CourseListView> {
  List<String> imgPath = [
    'assets/images/fi_2106463.png',
    'assets/images/fi_2134322.png',
    'assets/images/fi_3655592.png',
    'assets/images/fi_6714580.png',
  ];

  List<Map<String, String>> courses = [
    {
      "id": "1",
      "title": "ফ্লাটার শেখার কোর্স",
      "price": "৳999",
      "discountPrice": "৳1299",
      "discount": "২০% ছাড়",
      "imgPath": "assets/images/course_thumbnail.png",
    },
    {
      "id": "2",
      "title": "Flutter",
      "price": "৳799",
      "discountPrice": "৳999",
      "discount": "10% ছাড়",
      "imgPath": "assets/images/course_thumbnail.png",
    },
    {
      "id": "3",
      "title": "Java",
      "price": "৳1499",
      "discountPrice": "৳1699",
      "discount": "5% ছাড়",
      "imgPath": "assets/images/course_thumbnail.png",
    },
    {
      "id": "4",
      "title": "Java with script",
      "price": "৳1499",
      "discountPrice": "৳1699",
      "discount": "5% ছাড়",
      "imgPath": "assets/images/course_thumbnail.png",
    },
    {
      "id": "5",
      "title": "Flutter 2",
      "price": "৳1499",
      "discountPrice": "৳1699",
      "discount": "5% ছাড়",
      "imgPath": "assets/images/course_thumbnail.png",
    },
  ];

  List<Map<String, String>> filteredCourses = [];

  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    filteredCourses = courses; // Initially show all courses
  }

  // Method to filter courses based on search input
  void _filterCourses(String query) {
    setState(() {
      filteredCourses = courses
          .where((course) =>
              course['title']!.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: commonAppbar("কোর্সসমূহ", context),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Search Container
              InkWell(
                onTap: () {},
                child: SearchContainer(
                  controller: _searchController,
                  onChanged:
                      _filterCourses, // Bind onChanged to filtering function
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
              const CourseListHeader(text: 'টপ টেস্ট লিস্ট'),
              const Gap(10),

              for (int i = 0; i < filteredCourses.length; i++)
                Column(
                  children: [
                    InkWell(
                      onTap: () {
                        Nav().push(CourseDetailsView());
                      },
                      child: CourseCard(
                        title: filteredCourses[i]['title']!,
                        price: filteredCourses[i]['price']!,
                        discountPrice: filteredCourses[i]['discountPrice']!,
                        discount: filteredCourses[i]['discount']!,
                        imgPath: filteredCourses[i]['imgPath']!,
                      ),
                    )
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}
