import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:prostuti/core/services/nav.dart';
import 'package:prostuti/core/services/size_config.dart';
import 'package:prostuti/features/course/course_list/view/course_list_view.dart';
import 'package:prostuti/features/course/my_course/view/my_course_view.dart';

import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../widget/calendar_widget.dart';
import '../widget/category_card.dart';
import '../widget/leaderboard_card.dart';
import '../../../core/configs/app_colors.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final PageController _adController = PageController();

  // Temporary List of flashcards
  List<Flashcard> flashcards = [
    Flashcard(
        question: 'How many Americans died in WWII?', answer: 'Around 418,500'),
    Flashcard(question: 'What is the capital of France?', answer: 'Paris'),
    Flashcard(
        question: 'What is Flutter?',
        answer: 'A UI toolkit for building apps.'),
    Flashcard(
        question: 'What is Dart?',
        answer: 'A programming language for Flutter.'),
  ];

  List<Color> flashCardColors = [
    AppColors.leaderboardSecondLight,
    AppColors.leaderboardFirstLight,
    AppColors.leaderboardThirdLight,
    AppColors.leaderboardSecondLight,
  ];
  int currentIndex = 0;
  bool isShowingQuestion = true;
  List<bool> isShowingQuestionList = [];

  @override
  void initState() {
    super.initState();
    isShowingQuestionList = List.generate(flashcards.length, (index) => true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 500,
              child: Stack(
                children: [
                  Container(
                    height: 310,
                    padding: const EdgeInsets.all(16),
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppColors.homeScreenTopLight,
                          AppColors.homeScreenBottomLight,
                        ],
                        stops: [0.0, 0.5],
                        begin: Alignment.topRight,
                        end: Alignment.bottomLeft,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          children: [
                            const CircleAvatar(
                              backgroundImage: AssetImage(
                                'assets/images/test_dp.jpg',
                              ),
                            ),
                            const Gap(16),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'নাজমুল ইসলাম সিফাত',
                                  style:
                                      Theme.of(context).textTheme.titleSmall!,
                                ),
                                Text(
                                  'প্রফাইল দেখুন',
                                  style:
                                      Theme.of(context).textTheme.bodyMedium!,
                                ),
                              ],
                            ),
                          ],
                        ),
                        const Gap(24),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: SizeConfig.w(40)),
                          child: RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge!
                                  .copyWith(fontWeight: FontWeight.w600),
                              // Base style
                              children: const <TextSpan>[
                                TextSpan(
                                  text: 'এআই সমাধান ',
                                  style: TextStyle(
                                      color: AppColors
                                          .textActionSecondaryLight), // First part in blue
                                ),
                                TextSpan(
                                  text:
                                      'দিয়ে আপনার সমস্যার সমাধান করুন', // Second part in red
                                ),
                              ],
                            ),
                          ),
                        ),
                        const Gap(24),
                        GestureDetector(
                          onTap: () {
                            // Define what happens when the search box is tapped
                            print("Search box clicked!");
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: SizeConfig.w(16),
                                vertical: SizeConfig.h(12)),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                  color: AppColors.textTertiaryLight),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.2),
                                  // Light shadow
                                  spreadRadius: 2,
                                  blurRadius: 5,
                                  offset: const Offset(0, 2), // Shadow position
                                ),
                              ],
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'সার্চ করুন.....',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyLarge!
                                      .copyWith(
                                          color: AppColors.textTertiaryLight,
                                          fontWeight: FontWeight.w500),
                                ),
                                SvgPicture.asset(
                                    "assets/icons/search_icon.svg"),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    top: 300, // Adjust this to control the overlap
                    left: 16,
                    right: 16,
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: SizeConfig.w(4)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          InkWell(
                            onTap: () {
                              Nav().push(CourseListView());
                            },
                            child: const CategoryCard(
                              icon: "assets/icons/courses_icon.png",
                              text: 'কোর্সসমূহ',
                              image: 'assets/images/courses_background.png',
                            ),
                          ),
                          InkWell(
                            onTap: () => Nav().push(MyCourseView()),
                            child: const CategoryCard(
                              icon: "assets/icons/my_courses_icon.png",
                              text: 'আমার কোর্সসমূহ',
                              image: 'assets/images/my_courses_background.png',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Gap(25),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: Image.asset(
                        'assets/images/home_screen_ad.png',
                        height: SizeConfig.h(120),
                        width: MediaQuery.sizeOf(context).width,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const Gap(16),
                    SmoothPageIndicator(
                      controller: _adController,
                      count: 2, // Number of pages
                      effect: const ExpandingDotsEffect(
                        dotHeight: 8,
                        dotWidth: 8,
                        activeDotColor: Colors.blue,
                        dotColor: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const Gap(24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "আমার ক্যালেন্ডার",
                    style: Theme.of(context)
                        .textTheme
                        .titleSmall!
                        .copyWith(fontWeight: FontWeight.w600),
                  ),
                  Text(
                    "আরো দেখুন",
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        fontWeight: FontWeight.w500,
                        color: AppColors.textTertiaryLight),
                  ),
                ],
              ),
            ),
            const Gap(16),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CalendarWidget(),
                ],
              ),
            ),
            const Gap(24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "আমার ফ্ল্যাশকার্ড",
                    style: Theme.of(context)
                        .textTheme
                        .titleSmall!
                        .copyWith(fontWeight: FontWeight.w600),
                  ),
                  Text(
                    "আরো দেখুন",
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        fontWeight: FontWeight.w500,
                        color: AppColors.textTertiaryLight),
                  ),
                ],
              ),
            ),
            const Gap(16),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: SizedBox(
                height: 220,
                width: MediaQuery.of(context).size.width,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: flashcards.length,
                  itemBuilder: (context, index) {
                    return Row(
                      children: [
                        const Gap(10),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              isShowingQuestionList[index] =
                                  !isShowingQuestionList[
                                      index]; // Flip card state
                            });
                          },
                          child: Card(
                            elevation: 4,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Container(
                              padding: const EdgeInsets.all(24),
                              width: 300,
                              height: 220,
                              color: flashCardColors[index],
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      SvgPicture.asset(
                                        "assets/icons/sound_icon.svg",
                                        color: Colors.black,
                                      ),
                                      SvgPicture.asset(
                                          "assets/icons/favourite.svg"),
                                    ],
                                  ),
                                  const Gap(32),
                                  Center(
                                    child: Text(
                                      isShowingQuestionList[index]
                                          ? flashcards[index]
                                              .question // Show question
                                          : flashcards[index]
                                              .answer, // Show answer
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyLarge!
                                          .copyWith(
                                              fontWeight: FontWeight.w600),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  const Gap(32),
                                  Align(
                                    alignment: Alignment.bottomRight,
                                    child: SvgPicture.asset(
                                      "assets/icons/flash_card_share_icon.svg",
                                      color: Colors.black,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                        const Gap(5),
                      ],
                    );
                  },
                ),
              ),
            ),
            const Gap(24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "স্টুডেন্ট লিডারবোর্ড",
                    style: Theme.of(context)
                        .textTheme
                        .titleSmall!
                        .copyWith(fontWeight: FontWeight.w600),
                  ),
                  Text(
                    "আরো দেখুন",
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        fontWeight: FontWeight.w500,
                        color: AppColors.textTertiaryLight),
                  ),
                ],
              ),
            ),
            const Gap(16),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  LeaderboardSection(),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Colors.white,
          showUnselectedLabels: true,
          showSelectedLabels: true,
          selectedLabelStyle: Theme.of(context).textTheme.bodySmall!.copyWith(
              fontWeight: FontWeight.w600, color: AppColors.textTertiaryLight),
          unselectedLabelStyle: Theme.of(context).textTheme.bodySmall!.copyWith(
              fontWeight: FontWeight.w600, color: AppColors.textTertiaryLight),
          items: [
            BottomNavigationBarItem(
              icon: SvgPicture.asset("assets/icons/bottom_nav_home_select.svg"),
              label: "হোম",
            ),
            BottomNavigationBarItem(
              icon: SvgPicture.asset(
                  "assets/icons/bottom_nav_flash_card_unselect.svg"),
              label: "ফ্ল্যাশ কার্ড",
            ),
            BottomNavigationBarItem(
              icon:
                  SvgPicture.asset("assets/icons/bottom_nav_test_unselect.svg"),
              label: "টেস্ট",
            ),
            BottomNavigationBarItem(
              icon: SvgPicture.asset(
                  "assets/icons/bottom_nav_notification_unselect.svg"),
              label: "নটিফিকেশন",
            ),
            BottomNavigationBarItem(
              icon:
                  SvgPicture.asset("assets/icons/bottom_nav_chat_unselect.svg"),
              label: "ম্যাসেজ",
            ),
          ]),
    );
  }
}

class Flashcard {
  final String question;
  final String answer;

  Flashcard({required this.question, required this.answer});
}
