import 'package:flutter/material.dart';
import 'package:prostuti/core/services/localization_service.dart';

class FlashcardSearchContainer extends StatelessWidget {
  final TextEditingController controller;
  final Function(String) onChanged;

  const FlashcardSearchContainer({
    Key? key,
    required this.controller,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      decoration: BoxDecoration(
        color: Theme.of(context).unselectedWidgetColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Theme.of(context).colorScheme.onSecondary,
        ),
      ),
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        decoration: InputDecoration(
          hintText: context.l10n!.searchHint,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16),
          hintStyle: Theme.of(context).textTheme.bodyMedium,
          suffixIcon: Icon(
            Icons.search,
            color: Theme.of(context).unselectedWidgetColor,
          ),
        ),
      ),
    );
  }
}
