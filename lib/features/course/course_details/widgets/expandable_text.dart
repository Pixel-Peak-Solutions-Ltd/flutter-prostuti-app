import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prostuti/core/services/localization_service.dart';

import '../viewmodel/course_details_viewmodel.dart';

class ExpandableText extends ConsumerWidget {
  final String text;

  const ExpandableText({super.key, required this.text});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isExpanded = ref.watch(isExpandedProvider);
    final displayText =
        isExpanded || text.length <= 250 ? text : text.substring(0, 250);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          displayText,
          style: Theme.of(context).textTheme.bodyMedium,
          textAlign: TextAlign.justify,
        ),
        if (text.length > 250)
          TextButton(
            style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                minimumSize: const Size(50, 30),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                alignment: Alignment.centerLeft),
            onPressed: () {
              ref.read(isExpandedProvider.notifier).state = !isExpanded;
            },
            child: Text(
              isExpanded ? context.l10n!.showLess : context.l10n!.showMore,
              style: Theme.of(context)
                  .textTheme
                  .bodySmall!
                  .copyWith(color: Theme.of(context).colorScheme.secondary),
            ),
          ),
      ],
    );
  }
}
