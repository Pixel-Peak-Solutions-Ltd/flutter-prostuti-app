import 'package:flutter/material.dart';
import 'package:prostuti/core/services/localization_service.dart';

class SearchContainer extends StatelessWidget {
  final TextEditingController controller;
  final Function(String) onChanged; // New callback

  const SearchContainer({
    super.key,
    required this.controller,
    required this.onChanged, // Accept the callback here
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      decoration: BoxDecoration(
        border: Border.all(width: 0.2, color: Colors.grey.shade900),
        borderRadius: BorderRadius.circular(8),
        color: Theme.of(context).scaffoldBackgroundColor,
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: controller,
                textInputAction: TextInputAction.search,
                decoration: InputDecoration(
                  hintText: context.l10n!.searchCourses,
                  hintStyle: Theme.of(context).textTheme.bodyLarge,
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  disabledBorder: InputBorder.none,
                  isDense: true,
                  contentPadding: EdgeInsets.zero,
                ),
                onChanged:
                    onChanged, // Call onChanged whenever the text changes
              ),
            ),
            const Icon(
              Icons.search_outlined,
              size: 32,
            ),
          ],
        ),
      ),
    );
  }
}
