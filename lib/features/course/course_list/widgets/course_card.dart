import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:prostuti/common/widgets/common_widgets/common_widgets.dart';
import 'package:prostuti/core/services/localization_service.dart';

class CourseCard extends StatelessWidget with CommonWidgets {
  CourseCard({
    super.key,
    required this.title,
    required this.price,
    required this.imgPath,
    required this.priceType,
  });

  final String? title;
  final String? price, priceType;
  final String imgPath;

  // Define consistent image height
  final double imageHeight = 150.0;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Theme.of(context).scaffoldBackgroundColor,
        border: Border.all(
          color: Colors.grey.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image container with fixed height
          _buildImageContainer(context),
          const Gap(12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title ?? "No Name",
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium!
                      .copyWith(fontWeight: FontWeight.w800),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const Gap(12),
                courseEnrollRow(
                  priceType: priceType,
                  price: price,
                  theme: Theme.of(context),
                  title: context.l10n!.seeDetails,
                ),
                const Gap(8),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImageContainer(BuildContext context) {
    return Container(
      height: imageHeight,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
        color: Colors.grey.shade200,
      ),
      clipBehavior: Clip.antiAlias,
      child: _buildImage(context),
    );
  }

  Widget _buildImage(BuildContext context) {
    // Check if it's a network image
    if (imgPath.startsWith('http')) {
      return Image.network(
        imgPath,
        fit: BoxFit.cover,
        height: imageHeight,
        width: double.infinity,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;

          return _buildImagePlaceholder(context, loadingProgress);
        },
        errorBuilder: (context, error, stackTrace) {
          return _buildImageError(context);
        },
      );
    } else {
      // Asset image
      return Image.asset(
        imgPath,
        fit: BoxFit.cover,
        height: imageHeight,
        width: double.infinity,
        errorBuilder: (context, error, stackTrace) {
          return _buildImageError(context);
        },
      );
    }
  }

  Widget _buildImagePlaceholder(
      BuildContext context, ImageChunkEvent? loadingProgress) {
    // Calculate loading progress percentage
    final double? value = loadingProgress?.expectedTotalBytes != null
        ? loadingProgress!.cumulativeBytesLoaded /
            loadingProgress.expectedTotalBytes!
        : null;

    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          color: Theme.of(context).colorScheme.surfaceVariant,
        ),
        if (value != null)
          CircularProgressIndicator(
            value: value,
            strokeWidth: 2,
            color: Theme.of(context).colorScheme.primary,
          )
        else
          CircularProgressIndicator(
            strokeWidth: 2,
            color: Theme.of(context).colorScheme.primary,
          ),
      ],
    );
  }

  Widget _buildImageError(BuildContext context) {
    return Container(
      color: Colors.grey.shade300,
      height: imageHeight,
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            color: Colors.grey.shade700,
            size: 36,
          ),
          const Gap(8),
          Text(
            'Image not available',
            style: TextStyle(
              color: Colors.grey.shade700,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
