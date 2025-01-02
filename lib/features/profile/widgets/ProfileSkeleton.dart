import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../core/configs/app_colors.dart';
import 'custom_list_tile.dart';
import 'logout_button.dart';

class ProfileSkeleton extends StatelessWidget {
  const ProfileSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Skeletonizer(child: ListView(
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
      children: [
        Center(
          child: Column(
            children: [
              const CircleAvatar(
                radius: 50,
                backgroundImage: AssetImage('assets/images/test_dp.jpg'),
              ),
              const Gap(8),
              Text(
                '',
                style: Theme.of(context)
                    .textTheme
                    .titleSmall!
                    .copyWith(fontWeight: FontWeight.w500),
              ),
              const Gap(24),
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * .081,
                padding: EdgeInsets.all(16),
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
                    SvgPicture.asset("assets/icons/premium_upgrade.svg"),
                    const Gap(10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'প্রিমিয়ামে আপগ্রেড করুন',
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge!
                              .copyWith(
                              fontWeight: FontWeight.w600,
                              color: AppColors.textActionPrimaryLight),
                        ),
                        Text(
                          'আপনার পয়েন্ট',
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall!
                              .copyWith(
                              fontWeight: FontWeight.w400,
                              color: AppColors.textActionPrimaryLight),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
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
            icon: "assets/icons/language.svg", title: 'ভাষা', onTap: () {}),
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
          color: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4),
              side: const BorderSide(
                  width: 2, color: AppColors.shadeNeutralLight)),
          child: ListTile(
            leading: SvgPicture.asset("assets/icons/dark_theme.svg"),
            // Icon on the left
            title: const Text('ডার্ক থিম'),
            trailing: Switch(
              value: false,
              activeTrackColor: AppColors.textActionSecondaryLight,
              activeColor: Colors.white,
              inactiveThumbColor: Colors.white,
              inactiveTrackColor: AppColors.borderNormalLight,
              onChanged: (bool value) {
                print("isDarkTheme");
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
          onPressed: () {
            //logout
          },
        )
      ],
    ));
  }
}
