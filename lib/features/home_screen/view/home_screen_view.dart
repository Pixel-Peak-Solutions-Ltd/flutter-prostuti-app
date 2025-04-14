import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:logger/logger.dart';
import 'package:prostuti/common/helpers/theme_provider.dart';
import 'package:prostuti/core/services/localization_service.dart';
import 'package:prostuti/core/services/nav.dart';
import 'package:prostuti/features/chat/view/chat_view.dart';
import 'package:prostuti/features/course/course_list/view/course_list_view.dart';
import 'package:prostuti/features/course/my_course/view/my_course_view.dart';
import 'package:prostuti/features/leaderboard/widgets/leaderboard_section.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../../core/configs/app_colors.dart';
import '../../flashcard/model/flashcard_model.dart';
import '../../flashcard/view/flashcard_study_view.dart';
import '../../flashcard/view/flashcard_view.dart';
import '../../flashcard/viewmodel/flashcard_viewmodel.dart';
import '../../profile/view/profile_view.dart';
import '../../profile/viewmodel/profile_viewmodel.dart';
import '../widget/category_card.dart';
import '../widget/home_routine.dart';

// Updated provider to avoid unnecessary API calls
final cachedUserProfileProvider = Provider.autoDispose((ref) {
  // Just return the existing provider but only refresh it when necessary
  return ref.watch(userProfileProvider);
});

// Flag to track if we've already initialized the profile
final hasLoadedProfileProvider = StateProvider<bool>((ref) => false);

class HomeScreen extends ConsumerStatefulWidget {
  final int? initialIndex;

  const HomeScreen({super.key, this.initialIndex});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final PageController _adController = PageController();
  int _currentIndex = 0;

  final _log = Logger();

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
    if (widget.initialIndex != null) {
      _currentIndex = widget.initialIndex!;
    }
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
        return const ChatView();
      default:
        return _buildHomeContent();
    }
  }

  // Rebuilt home content with LayoutBuilder for better adaptivity
  Widget _buildHomeContent() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final maxWidth = constraints.maxWidth;

        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top section fades in
              _buildTopSection(maxWidth).animate().fadeIn(duration: 575.ms),

              const Gap(16),

              // Ad section slides in
              // _buildAdSection(maxWidth)
              //     .animate()
              //     .moveX(begin: 20, end: 0, duration: 500.ms),

              const Gap(16),

              // Calendar title bounces in
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                child: Text(
                  context.l10n!.myCalendar,
                  style: Theme.of(context)
                      .textTheme
                      .titleSmall!
                      .copyWith(fontWeight: FontWeight.w600),
                ),
              ).animate().moveX(duration: 674.ms, curve: Curves.easeIn),

              // Routine widget fades in
              const HomeRoutineWidget()
                  .animate()
                  .moveX(begin: 20, end: 0, duration: 500.ms),

              const Gap(16),

              // Flashcard header slides in
              _buildSectionHeader(context, "আমার ফ্ল্যাশকার্ড")
                  .animate()
                  .moveX(begin: -20, end: 0, duration: 400.ms),

              const Gap(8),

              // Flashcard section shimmers in
              _buildFlashcardSection(maxWidth)
                  .animate()
                  .fadeIn()
                  .shimmer(duration: 1000.ms),

              const Gap(16),

              // Leaderboard section zooms in
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: LeaderboardSection(),
              ).animate().scale(duration: 500.ms),

              const Gap(16),
            ],
          ),
        );
      },
    );
  }

  Widget _buildProfileShimmer(BuildContext context) {
    return Row(
      children: [
        // Avatar placeholder
        Container(
          width: 40,
          height: 40,
          decoration: const BoxDecoration(
            color: Colors.grey,
            shape: BoxShape.circle,
          ),
        ),
        const Gap(16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Name placeholder
            Container(
              width: 120,
              height: 16,
              decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            const SizedBox(height: 4),
            // "View profile" text placeholder
            Container(
              width: 80,
              height: 14,
              decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ],
        ),
      ],
    ).animate(onPlay: (controller) => controller.repeat()).shimmer(
          duration: 1200.ms,
          color: Theme.of(context).brightness == Brightness.dark
              ? Colors.white.withOpacity(0.7)
              : Colors.white.withOpacity(0.9),
          size: 0.8,
          delay: 300.ms,
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
                      Navigator.push(
                        context,
                        PageRouteBuilder(
                          pageBuilder:
                              (context, animation, secondaryAnimation) =>
                                  UserProfileView(),
                          transitionsBuilder:
                              (context, animation, secondaryAnimation, child) {
                            const begin = Offset(0.0, 1.0); // Start from bottom
                            const end = Offset.zero; // End at original position
                            const curve = Curves.easeInOut;

                            final tween = Tween(begin: begin, end: end)
                                .chain(CurveTween(curve: curve));
                            final offsetAnimation = animation.drive(tween);

                            return SlideTransition(
                              position: offsetAnimation,
                              child: child,
                            );
                          },
                        ),
                      );
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
                        return _buildProfileShimmer(context);
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
    final flashcardsAsync = ref.watch(exploreFlashcardsProvider);

    return SizedBox(
      height: 220, // Fixed height for horizontal scroll
      child: flashcardsAsync.when(
        data: (flashcards) {
          if (flashcards.isEmpty) {
            return Center(
              child: Text(
                context.l10n!.emptyFlashcardMessage,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            );
          }

          return _buildHorizontalFlashcardList(flashcards, maxWidth);
        },
        loading: () => _buildHorizontalFlashcardListLoading(maxWidth),
        error: (error, stack) => Center(
          child: Text('${context.l10n!.error}: ${error.toString()}'),
        ),
      ),
    );
  }

  Widget _buildHorizontalFlashcardListLoading(double maxWidth) {
    // Generate fake flashcard data for skeleton loading
    final fakeFlashcards = List<Flashcard>.generate(
      3, // Number of skeleton items to show
      (index) => Flashcard(
        title: 'Loading flashcard title',
        studentId: Student(name: 'Loading author'),
      ),
    );

    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: fakeFlashcards.length,
      itemBuilder: (context, index) {
        return Container(
          width: maxWidth * 0.8, // 80% of screen width
          padding: EdgeInsets.only(
            left: index == 0 ? 16 : 8,
            right: index == fakeFlashcards.length - 1 ? 16 : 8,
          ),
          child: Skeletonizer(
            enabled: true,
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.grey[200], // Light grey background for skeleton
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Sound button skeleton
                        Container(
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            shape: BoxShape.circle,
                          ),
                        ),
                        // Favorite button skeleton
                        Container(
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            shape: BoxShape.circle,
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    // Title skeleton
                    Container(
                      width: double.infinity,
                      height: 16,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      width: maxWidth * 0.5,
                      height: 16,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    const Spacer(),
                    // Author skeleton
                    Container(
                      width: 100,
                      height: 12,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildHorizontalFlashcardList(
      List<Flashcard> flashcards, double maxWidth) {
    final flashcardNotifier = ref.read(exploreFlashcardsProvider.notifier);
    final isLoadingMore = flashcardNotifier.isLoadingMore;

    return NotificationListener<ScrollNotification>(
      onNotification: (scrollNotification) {
        if (scrollNotification.metrics.pixels >=
            scrollNotification.metrics.maxScrollExtent * 0.8) {
          // Load more when 80% scrolled
          flashcardNotifier.loadMoreData();
        }
        return false;
      },
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 3,
        itemBuilder: (context, index) {
          if (index == flashcards.length) {
            // Loading indicator at the end
            return const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 80),
              child: Center(child: CircularProgressIndicator()),
            );
          }

          final flashcard = flashcards[index];
          final baseColor = _getFlashcardColor(index);

          return InkWell(
            onTap: () {
              Nav().push(FlashcardStudyView(
                  flashcardId: flashcards[index].sId!,
                  flashcardTitle: flashcards[index].title!));
            },
            child: Container(
              width: maxWidth * 0.8, // 80% of screen width
              padding: EdgeInsets.only(
                left: index == 0 ? 16 : 8,
                right: index == flashcards.length - 1 ? 16 : 8,
                top: 12,
                bottom: 12,
              ),
              child: Card(
                elevation: 8,
                shadowColor: baseColor.withOpacity(0.5),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Stack(
                    children: [
                      // Custom painter for wavy background
                      Positioned.fill(
                        child: CustomPaint(
                          painter: WavyBackgroundPainter(
                            baseColor: _getFlashcardColor(index),
                          ),
                        ),
                      ),
                      // Content
                      Padding(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            if (flashcard.studentId != null)
                              Align(
                                alignment: Alignment.topRight,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.3),
                                    borderRadius: BorderRadius.circular(20),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onError,
                                        blurRadius: 1,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: Text(
                                    'Flashcard By ${flashcard.studentId!.name}',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodySmall!
                                        .copyWith(
                                          fontWeight: FontWeight.w600,
                                        ),
                                  ),
                                ),
                              ),
                            const Spacer(),
                            Center(
                              child: Text(
                                flashcard.title!,
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineSmall!
                                    .copyWith(
                                  fontWeight: FontWeight.bold,
                                  shadows: [
                                    Shadow(
                                      blurRadius: 4.0,
                                      color: Colors.black.withOpacity(0.3),
                                      offset: const Offset(1.0, 1.0),
                                    ),
                                  ],
                                ),
                                textAlign: TextAlign.center,
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const Spacer(),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 8,
                                  ),
                                  decoration: BoxDecoration(
                                    color:
                                        Theme.of(context).colorScheme.secondary,
                                    borderRadius: BorderRadius.circular(30),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.1),
                                        blurRadius: 4,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: const Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        'View',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      SizedBox(width: 8),
                                      Icon(
                                        Icons.arrow_forward,
                                        color: Colors.white,
                                        size: 18,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
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

  Color _getFlashcardColor(int index) {
    final colors = [
      Theme.of(context).colorScheme.secondary,
      Theme.of(context).unselectedWidgetColor,
      Theme.of(context).colorScheme.error,
      Colors.orange,
      Colors.green,
    ];
    return colors[index % colors.length];
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

// ---------

class WavyBackgroundPainter extends CustomPainter {
  final Color baseColor;

  WavyBackgroundPainter({
    required this.baseColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Create gradient colors based on the baseColor
    final Rect rect = Offset.zero & size;

    // Create lighter and darker shades of the base color
    final Color lighterColor = _lightenColor(baseColor, 0.15);
    final Color darkerColor = _darkenColor(baseColor, 0.15);

    final gradient = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        lighterColor,
        baseColor,
        darkerColor,
      ],
    );

    final paint = Paint()
      ..shader = gradient.createShader(rect)
      ..style = PaintingStyle.fill;

    // Fill background
    canvas.drawRect(rect, paint);

    // Paint the waves
    _paintWaves(canvas, size);
  }

  Color _lightenColor(Color color, double amount) {
    final hsl = HSLColor.fromColor(color);
    return hsl
        .withLightness((hsl.lightness + amount).clamp(0.0, 1.0))
        .toColor();
  }

  Color _darkenColor(Color color, double amount) {
    final hsl = HSLColor.fromColor(color);
    return hsl
        .withLightness((hsl.lightness - amount).clamp(0.0, 1.0))
        .toColor();
  }

  void _paintWaves(Canvas canvas, Size size) {
    // First wave
    final wavePaint = Paint()
      ..color = Colors.white.withOpacity(0.15)
      ..style = PaintingStyle.fill;

    final path1 = Path();
    path1.moveTo(0, size.height * 0.3);

    path1.quadraticBezierTo(
      size.width * 0.25,
      size.height * 0.2,
      size.width * 0.5,
      size.height * 0.3,
    );

    path1.quadraticBezierTo(
      size.width * 0.75,
      size.height * 0.4,
      size.width,
      size.height * 0.3,
    );

    path1.lineTo(size.width, size.height);
    path1.lineTo(0, size.height);
    path1.close();

    canvas.drawPath(path1, wavePaint);

    // Second wave (slightly darker)
    final wavePaint2 = Paint()
      ..color = Colors.white.withOpacity(0.1)
      ..style = PaintingStyle.fill;

    final path2 = Path();
    path2.moveTo(0, size.height * 0.5);

    path2.quadraticBezierTo(
      size.width * 0.25,
      size.height * 0.6,
      size.width * 0.5,
      size.height * 0.5,
    );

    path2.quadraticBezierTo(
      size.width * 0.75,
      size.height * 0.4,
      size.width,
      size.height * 0.5,
    );

    path2.lineTo(size.width, size.height);
    path2.lineTo(0, size.height);
    path2.close();

    canvas.drawPath(path2, wavePaint2);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
