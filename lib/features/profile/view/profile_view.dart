import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:prostuti/common/helpers/theme_provider.dart';
import 'package:prostuti/common/widgets/common_widgets/common_widgets.dart';
import 'package:prostuti/core/services/nav.dart';
import 'package:prostuti/features/auth/login/view/login_view.dart';

import '../../../common/view_model/auth_notifier.dart';
import '../../../core/configs/app_colors.dart';
import '../../flashcard/services/localization_service.dart';
import '../../payment/view/subscription_view.dart';
import '../../payment/viewmodel/check_subscription.dart';
import '../viewmodel/profile_viewmodel.dart';
import '../widgets/ProfileSkeleton.dart';
import '../widgets/custom_list_tile.dart';
import '../widgets/logout_button.dart';

class UserProfileView extends ConsumerWidget with CommonWidgets {
  UserProfileView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDarkTheme = ref.watch(
        themeNotifierProvider.select((value) => value == ThemeMode.dark));
    final userProfileAsyncValue = ref.watch(userProfileProvider);
    final subscriptionAsyncValue = ref.watch(userSubscribedProvider);

// Get current locale
    final currentLocale = ref.watch(localeProvider);
    final currentLanguage = languages.firstWhere(
      (lang) => lang.code == currentLocale.languageCode,
      orElse: () => languages[1], // Default to Bangla
    );

    return Scaffold(
      appBar: commonAppbar('আমার প্রোফাইল'),
      body: userProfileAsyncValue.when(
        data: (userData) {
          return ListView(
            padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
            children: [
              Center(
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundImage: userData.data!.image == null
                          ? const AssetImage('assets/images/test_dp.jpg')
                              as ImageProvider
                          : CachedNetworkImageProvider(
                              userData.data!.image!.path!),
                    ),
                    const Gap(8),
                    Text(
                      '${userData.data!.name}',
                      style: Theme.of(context)
                          .textTheme
                          .titleSmall!
                          .copyWith(fontWeight: FontWeight.w500),
                    ),
                    const Gap(24),
                    subscriptionAsyncValue.when(
                      data: (data) {
                        return InkWell(
                          onTap: data
                              ? () {}
                              : () => Nav().push(SubscriptionView()),
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.height * .081,
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              image: const DecorationImage(
                                image: AssetImage(
                                    "assets/images/upgrade_to_premium_background.png"),
                                fit: BoxFit.cover,
                              ),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Row(
                              children: [
                                SvgPicture.asset(
                                    "assets/icons/premium_upgrade.svg"),
                                const Gap(10),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      data
                                          ? "আপনি প্রিমিয়াম প্ল্যানে আছেন"
                                          : 'প্রিমিয়ামে আপগ্রেড করুন',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyLarge!
                                          .copyWith(
                                              fontWeight: FontWeight.w600,
                                              color: AppColors
                                                  .textActionPrimaryLight),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                      error: (error, stackTrace) {
                        return Text(error.toString());
                      },
                      loading: () {
                        return Container();
                      },
                    )
                  ],
                ),
              ),
              const Gap(24),
              CustomListTile(
                icon: "assets/icons/your_point.svg",
                title: 'আপনার পয়েন্ট',
                onTap: () {},
              ),
              CustomListTile(
                icon: "assets/icons/category.svg",
                title: 'ক্যাটাগরি',
                onTap: () {},
              ),
              const Gap(24),
              Text(
                "একাউন্ট",
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
              ),
              const Gap(10),
              CustomListTile(
                  icon: "assets/icons/user.svg",
                  title: 'প্রোফাইল তথ্যাবলী',
                  onTap: () {}),
              CustomListTile(
                icon: "assets/icons/language.svg",
                title: 'ভাষা',
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      currentLanguage.localName,
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 14,
                      ),
                    ),
                    const Icon(Icons.chevron_right, size: 20),
                  ],
                ),
                onTap: () => _showLanguageSelector(context, ref),
              ),
              const Gap(24),
              Text(
                "আমার আইটেম",
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
              ),
              const Gap(10),
              CustomListTile(
                  icon: "assets/icons/courses.svg",
                  title: 'আমার কোর্সসমহূ',
                  onTap: () {}),
              CustomListTile(
                  icon: "assets/icons/favourites_profile.svg",
                  title: 'ফেভারিট',
                  onTap: () {}),
              CustomListTile(
                  icon: "assets/icons/progress_history.svg",
                  title: 'টেস্ট হিস্টোরি',
                  onTap: () {}),
              const Gap(24),
              Text(
                "সেটিংস",
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
              ),
              const Gap(10),
              Card(
                color: Theme.of(context).colorScheme.primary,
                elevation: 0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                    side: const BorderSide(
                        width: 2, color: AppColors.shadeNeutralLight)),
                child: ListTile(
                  leading: SvgPicture.asset(
                    "assets/icons/dark_theme.svg",
                    fit: BoxFit.cover,
                    colorFilter: const ColorFilter.linearToSrgbGamma(),
                  ),
                  // Icon on the left
                  title: Text('ডার্ক থিম'),
                  trailing: Switch(
                    value: isDarkTheme,
                    activeTrackColor: AppColors.textActionSecondaryLight,
                    activeColor: Colors.white,
                    inactiveThumbColor: Colors.white,
                    inactiveTrackColor: AppColors.borderNormalLight,
                    onChanged: (bool value) {
                      ref.read(themeNotifierProvider.notifier).toggleTheme();
                    },
                  ), // Switch on the right
                ),
              ),
              const Gap(24),
              Text(
                "অন্যান্য",
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
              ),
              const Gap(10),
              CustomListTile(
                  icon: "assets/icons/subscription.svg",
                  title: 'সাবসক্রিপশন',
                  onTap: () {}),
              CustomListTile(
                  icon: "assets/icons/customer-support.svg",
                  title: 'সাপোর্ট',
                  onTap: () {}),
              CustomListTile(
                  icon: "assets/icons/f_and_q.svg",
                  title: 'এফ এন্ড কিউ',
                  onTap: () {}),
              CustomListTile(
                  icon: "assets/icons/terms.svg",
                  title: 'টার্মস এন্ড কন্ডিশন',
                  onTap: () {}),
              CustomListTile(
                  icon: "assets/icons/privacy.svg",
                  title: 'প্রাইভেসি পলিসি',
                  onTap: () {}),
              const Gap(24),
              LogoutButton(
                onPressed: () async {
                  final authNotifier = ref.read(authNotifierProvider.notifier);
                  await authNotifier.clearTokens();
                  Nav().pushAndRemoveUntil(const LoginView());
                },
              )
            ],
          );
        },
        error: (error, stackTrace) {
          return Text("$error");
        },
        loading: () {
          return const ProfileSkeleton();
        },
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
              icon:
                  SvgPicture.asset("assets/icons/bottom_nav_home_unselect.svg"),
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

  void _showLanguageSelector(BuildContext context, WidgetRef ref) {
    final currentLocale = ref.watch(localeProvider);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          return Container(
            padding: EdgeInsets.only(
              top: 16,
              left: 16,
              right: 16,
              bottom: MediaQuery.of(context).viewInsets.bottom + 16,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header with title and close button
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
                    ),
                    Text(
                      'ভাষা নির্বাচন করুন',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(width: 48), // Balance space
                  ],
                ),
                const SizedBox(height: 24),

                // Language options
                ...languages.map((language) => _buildLanguageOption(
                    context, ref, language,
                    isSelected: currentLocale.languageCode == language.code)),

                const SizedBox(height: 16),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildLanguageOption(
      BuildContext context, WidgetRef ref, Language language,
      {required bool isSelected}) {
    return InkWell(
      onTap: () {
        ref.read(localeProvider.notifier).changeLanguage(language.code);
        Navigator.pop(context);
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFF2970FF).withOpacity(0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected
                ? const Color(0xFF2970FF)
                : Colors.grey.withOpacity(0.5),
            width: 1.5,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              language.localName,
              style: TextStyle(
                fontSize: 16,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected ? const Color(0xFF2970FF) : null,
              ),
            ),
            if (isSelected)
              const Icon(
                Icons.check_circle,
                color: Color(0xFF2970FF),
              ),
          ],
        ),
      ),
    );
  }
}
