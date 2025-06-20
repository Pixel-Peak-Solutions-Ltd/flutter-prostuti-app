import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class TestButton extends StatelessWidget {
  final String label;
  final Color borderColor;
  final String svgAsset;
  final String icon;
  final VoidCallback onTap;
  final bool fullWidth;

  const TestButton({
    super.key,
    required this.label,
    required this.borderColor,
    required this.svgAsset,
    required this.onTap,
    this.fullWidth = false,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: fullWidth ? double.infinity : null,
        height: 170,
        decoration: BoxDecoration(
            border: Border.all(color: borderColor),
            borderRadius: BorderRadius.circular(10)),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Positioned.fill(
              child: Material(
                borderRadius: BorderRadius.circular(8),
                clipBehavior: Clip.antiAlias,
                child: SvgPicture.asset(
                  svgAsset,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            // Button label
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize:MainAxisSize.max ,
              children: [
                Image.asset(
                  icon,
                  height: 50,
                  width: 50,
                  fit: BoxFit.contain,
                ),
                const SizedBox(height: 16,),
                Text(
                  label,
                  style: TextStyle(
                    color: borderColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
