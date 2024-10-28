import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:prostuti/common/widgets/long_button.dart';
import 'package:prostuti/features/login/view/login_view.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnboardingView extends ConsumerStatefulWidget {
  const OnboardingView({super.key});

  @override
  ConsumerState<OnboardingView> createState() => _OnboardingViewState();
}

class _OnboardingViewState extends ConsumerState<OnboardingView> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    Timer.periodic(const Duration(seconds: 5), (Timer timer) {
      if (_currentIndex < 1) {
        _currentIndex++;
      } else {
        _currentIndex = 0;
      }

      _pageController.animateToPage(
        _currentIndex,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeIn,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
        PageView(
          controller: _pageController,
          reverse: false,
          onPageChanged: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(20.0),
                  child: Image.asset(
                    'assets/images/onboarding_image1.png',
                    height: 180,
                    width: 270,
                    fit: BoxFit.contain,
                  ),
                ),
                // Add your images to assets folder
                const Gap(50),
                 Text(
                  'মকটেষ্ট',
                    style: Theme.of(context).textTheme.titleLarge,
                ),
                const Gap(16),
                 Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    'It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged.',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.titleSmall!.copyWith(fontWeight: FontWeight.w500),
                  ),
                ),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(20.0),
                  child: Image.asset(
                    'assets/images/onboarding_image2.png',
                    height: 180,
                    width: 180,
                    fit: BoxFit.contain,
                  ),
                ),
                // Add your images to assets folder
                const Gap(50),
                 Text(
                  'ক্লিয়ার ইউর ডাউটস',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const Gap(16),
                 Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    'It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged.',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.titleSmall!.copyWith(fontWeight: FontWeight.w500),
                  ),
                ),
              ],
            ),
          ],
        ),
        Positioned(
          bottom: 230, // Adjust position for indicators
          left: 0,
          right: 0,
          child: Center(
            child: SmoothPageIndicator(
              controller: _pageController,
              count: 2, // Number of pages
              effect: const ExpandingDotsEffect(
                dotHeight: 8,
                dotWidth: 8,
                activeDotColor: Colors.blue,
                dotColor: Colors.grey,
              ),
            ),
          ),
        ),
        Positioned(
          bottom: 40,
          left: 0,
          right: 0,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: LongButton(onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => const LoginView(),
              ));
            }, text: 'শুরু করুন'),
          ),
        ),
      ]),
    );
  }
}
