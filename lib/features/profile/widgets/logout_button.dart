import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:prostuti/core/configs/app_colors.dart';

class LogoutButton extends StatelessWidget {
  final VoidCallback onPressed;

  const LogoutButton({Key? key, required this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(

      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.textActionTertiaryDark,
        elevation: 4,
        shadowColor: AppColors.backgroundActionSecondaryLight,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12), // Rounded corners
        ),
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset("assets/icons/logout.svg"),
          const SizedBox(width: 10),
          Text(
            "লগ আউট", // Bengali text for "Logout"
            style: Theme.of(context).textTheme.titleSmall!.copyWith(color: AppColors.textActionSecondaryLight),
            ),
        ],
      ),
    );
  }
}
