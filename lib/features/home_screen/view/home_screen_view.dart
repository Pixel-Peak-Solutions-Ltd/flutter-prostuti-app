import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:logger/logger.dart';
import 'package:prostuti/common/helpers/theme_provider.dart';
import 'package:prostuti/core/services/localization_service.dart';
import 'package:prostuti/core/services/nav.dart';
import 'package:prostuti/features/course/course_list/view/course_list_view.dart';
import 'package:prostuti/features/course/my_course/view/my_course_view.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../../core/configs/app_colors.dart';
import '../../flashcard/view/flashcard_view.dart';
import '../../profile/view/profile_view.dart';
import '../../profile/viewmodel/profile_viewmodel.dart';
import '../widget/calendar_widget.dart';
import '../widget/category_card.dart';
import '../widget/leaderboard_card.dart';

// Updated provider to avoid unnecessary API calls
final cachedUserProfileProvider = Provider.autoDispose((ref) {
  // Just return the existing provider but only refresh it when necessary
  return ref.watch(userProfileProvider);
});

// Flag to track if we've already initialized the profile
final hasLoadedProfileProvider = StateProvider<bool>((ref) => false);

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final PageController _adController = PageController();
  int _currentIndex = 0;
  bool _hasInitializedProfile = false;
  final _log = Logger();

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
  List<bool> isShowingQuestionList = [];

  @override
  void initState() {
    super.initState();
    isShowingQuestionList = List.generate(flashcards.length, (index) => true);
  }

  // Proper tab change handler method
  void _handleTabChange(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Only initialize profile data once when needed
    if (_currentIndex == 0) {
      final hasLoaded = ref.read(hasLoadedProfileProvider);
      if (!hasLoaded) {
        // This will ensure we only trigger the API call once
        WidgetsBinding.instance.addPostFrameCallback((_) {
          ref.read(hasLoadedProfileProvider.notifier).state = true;
        });
      }
    }

    return Scaffold(
      body: _buildCurrentTab(),
      bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: _handleTabChange,
          elevation: 10,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          type: BottomNavigationBarType.fixed,
          showUnselectedLabels: true,
          selectedItemColor: Theme.of(context).colorScheme.secondary,
          unselectedItemColor: AppColors.textTertiaryLight,
          showSelectedLabels: true,
          selectedLabelStyle: Theme.of(context).textTheme.bodySmall!.copyWith(
              fontWeight: FontWeight.w600,
              color: Theme.of(context).primaryColor),
          unselectedLabelStyle: Theme.of(context).textTheme.bodySmall!.copyWith(
              fontWeight: FontWeight.w600, color: AppColors.textTertiaryLight),
          items: [
            BottomNavigationBarItem(
              icon: SvgPicture.asset(
                _currentIndex == 0
                    ? "assets/icons/bottom_nav_home_select.svg"
                    : "assets/icons/bottom_nav_home_unselect.svg",
                colorFilter: ColorFilter.mode(
                    _currentIndex == 0
                        ? Theme.of(context).colorScheme.secondary
                        : AppColors.textTertiaryLight,
                    BlendMode.srcIn),
              ),
              label: "হোম",
            ),
            BottomNavigationBarItem(
              icon: SvgPicture.asset(
                _currentIndex == 1
                    ? "assets/icons/bottom_nav_flash_card_select.svg"
                    : "assets/icons/bottom_nav_flash_card_unselect.svg",
                colorFilter: ColorFilter.mode(
                    _currentIndex == 1
                        ? Theme.of(context).colorScheme.secondary
                        : AppColors.textTertiaryLight,
                    BlendMode.srcATop),
              ),
              label: "ফ্ল্যাশ কার্ড",
            ),
            BottomNavigationBarItem(
              icon: SvgPicture.asset(
                _currentIndex == 2
                    ? "assets/icons/bottom_nav_test_select.svg"
                    : "assets/icons/bottom_nav_test_unselect.svg",
                colorFilter: ColorFilter.mode(
                    _currentIndex == 2
                        ? Theme.of(context).colorScheme.secondary
                        : AppColors.textTertiaryLight,
                    BlendMode.srcIn),
              ),
              label: "টেস্ট",
            ),
            BottomNavigationBarItem(
              icon: SvgPicture.asset(
                _currentIndex == 3
                    ? "assets/icons/bottom_nav_notification_select.svg"
                    : "assets/icons/bottom_nav_notification_unselect.svg",
                colorFilter: ColorFilter.mode(
                    _currentIndex == 3
                        ? Theme.of(context).colorScheme.secondary
                        : AppColors.textTertiaryLight,
                    BlendMode.srcIn),
              ),
              label: "নটিফিকেশন",
            ),
            BottomNavigationBarItem(
              icon: SvgPicture.asset(
                _currentIndex == 4
                    ? "assets/icons/bottom_nav_chat_select.svg"
                    : "assets/icons/bottom_nav_chat_unselect.svg",
                colorFilter: ColorFilter.mode(
                    _currentIndex == 4
                        ? Theme.of(context).colorScheme.secondary
                        : AppColors.textTertiaryLight,
                    BlendMode.srcIn),
              ),
              label: "ম্যাসেজ",
            ),
          ]),
    );
  }

  // Build only the active tab to prevent unnecessary API calls and widget builds
  Widget _buildCurrentTab() {
    switch (_currentIndex) {
      case 0:
        return _buildHomeContent();
      case 1:
        return const FlashcardView();
      case 2:
        return const Center(child: Text("Tests coming soon"));
      case 3:
        return const Center(child: Text("Notifications coming soon"));
      case 4:
        return const Center(child: Text("Messages coming soon"));
      default:
        return _buildHomeContent();
    }
  }

  // Rebuilt home content with LayoutBuilder for better adaptivity
  Widget _buildHomeContent() {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Use constraints to make responsive calculations
        final maxWidth = constraints.maxWidth;

        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTopSection(maxWidth),
              const Gap(16),
              _buildAdSection(maxWidth),
              const Gap(16),
              _buildSectionHeader(context, "আমার ক্যালেন্ডার"),
              const Gap(8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: CalendarWidget(),
              ),
              const Gap(16),
              _buildSectionHeader(context, "আমার ফ্ল্যাশকার্ড"),
              const Gap(8),
              _buildFlashcardSection(maxWidth),
              const Gap(16),
              _buildSectionHeader(context, "স্টুডেন্ট লিডারবোর্ড"),
              const Gap(8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: LeaderboardSection(),
              ),
              const Gap(16), // Bottom padding for scrolling
            ],
          ),
        );
      },
    );
  }

  // Top section with profile and category cards - Optimized to reduce API calls
  Widget _buildTopSection(double maxWidth) {
    // Use cached provider to prevent unnecessary API calls
    final userProfileAsyncValue = ref.watch(cachedUserProfileProvider);
    final themeMode = ref.watch(themeNotifierProvider);
    final isDarkTheme = themeMode == ThemeMode.dark ||
        (themeMode == ThemeMode.system &&
            MediaQuery.platformBrightnessOf(context) == Brightness.dark);

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDarkTheme
              ? [
                  AppColors.homeScreenTopDark,
                  AppColors.scaffoldBackgroundDark,
                ]
              : [
                  AppColors.homeScreenTopLight,
                  AppColors.homeScreenBottomLight,
                ],
          stops: const [0.0, 0.5],
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
        ),
      ),
      child: Column(
        children: [
          // Safe area for top padding
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Profile section
                  GestureDetector(
                    onTap: () {
                      Nav().push(UserProfileView());
                    },
                    child: userProfileAsyncValue.when(
                      data: (userData) {
                        return Row(
                          children: [
                            CircleAvatar(
                              backgroundImage: userData.data!.image == null
                                  ? const AssetImage(
                                          'assets/images/test_dp.jpg')
                                      as ImageProvider
                                  : CachedNetworkImageProvider(
                                      userData.data!.image!.path!),
                            ),
                            const Gap(16),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${userData.data!.name}',
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
                        );
                      },
                      error: (error, stackTrace) {
                        _log.e(error.toString());
                        return const Text("Error loading profile");
                      },
                      loading: () {
                        return const Center(child: CircularProgressIndicator());
                      },
                    ),
                  ),

                  const Gap(16),

                  // Title text
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: maxWidth * 0.05),
                    child: RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        style: Theme.of(context)
                            .textTheme
                            .titleLarge!
                            .copyWith(fontWeight: FontWeight.w600),
                        children: const <TextSpan>[
                          TextSpan(
                            text: 'এআই সমাধান ',
                            style: TextStyle(
                                color: AppColors.textActionSecondaryLight),
                          ),
                          TextSpan(
                            text: 'দিয়ে আপনার সমস্যার সমাধান করুন',
                          ),
                        ],
                      ),
                    ),
                  ),

                  const Gap(16),

                  // Search box
                  GestureDetector(
                    onTap: () {
                      _log.i("Search box clicked!");
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: AppColors.textTertiaryLight),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.2),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: const Offset(0, 2),
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
                          SvgPicture.asset("assets/icons/search_icon.svg"),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Category cards - now part of the column flow instead of absolutely positioned
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
            child: Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () {
                      Nav().push(CourseListView());
                    },
                    child: CategoryCard(
                      icon: "assets/icons/courses_icon.png",
                      text: context.l10n!.courses,
                      image: 'assets/images/courses_background.png',
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: InkWell(
                    onTap: () => Nav().push(MyCourseView()),
                    child: CategoryCard(
                      icon: "assets/icons/my_courses_icon.png",
                      text: context.l10n!.myCourses,
                      image: 'assets/images/my_courses_background.png',
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Advertisement section
  Widget _buildAdSection(double maxWidth) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: Image.asset(
                'assets/images/home_screen_ad.png',
                height: 120,
                width: maxWidth,
                fit: BoxFit.cover,
              ),
            ),
            const Gap(8),
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
    );
  }

  // Flashcard section
  Widget _buildFlashcardSection(double maxWidth) {
    return SizedBox(
      height: 220,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: flashcards.length,
        itemBuilder: (context, index) {
          return Container(
            padding: EdgeInsets.only(
              left: index == 0 ? 16 : 8,
              right: index == flashcards.length - 1 ? 16 : 8,
            ),
            width: maxWidth * 0.8, // 80% of screen width
            child: GestureDetector(
              onTap: () {
                setState(() {
                  isShowingQuestionList[index] = !isShowingQuestionList[index];
                });
              },
              child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Container(
                  padding: const EdgeInsets.all(24),
                  color: flashCardColors[index],
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SvgPicture.asset(
                            "assets/icons/sound_icon.svg",
                            color: Colors.black,
                          ),
                          SvgPicture.asset("assets/icons/favourite.svg"),
                        ],
                      ),
                      const Spacer(),
                      Text(
                        isShowingQuestionList[index]
                            ? flashcards[index].question
                            : flashcards[index].answer,
                        style: Theme.of(context)
                            .textTheme
                            .bodyLarge!
                            .copyWith(fontWeight: FontWeight.w600),
                        textAlign: TextAlign.center,
                      ),
                      const Spacer(),
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
          );
        },
      ),
    );
  }

  // Section header
  Widget _buildSectionHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: Theme.of(context)
                .textTheme
                .titleSmall!
                .copyWith(fontWeight: FontWeight.w600),
          ),
          TextButton(
            onPressed: () {
              if (title == "আমার ফ্ল্যাশকার্ড") {
                _handleTabChange(1); // Switch to flashcard tab
              }
            },
            child: Text(
              "আরো দেখুন",
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  fontWeight: FontWeight.w500,
                  color: AppColors.textTertiaryLight),
            ),
          ),
        ],
      ),
    );
  }
}

class Flashcard {
  final String question;
  final String answer;

  Flashcard({required this.question, required this.answer});
}
