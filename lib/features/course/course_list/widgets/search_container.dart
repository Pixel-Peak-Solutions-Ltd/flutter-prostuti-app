import 'package:flutter/material.dart';

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
        borderRadius: BorderRadius.circular(8),
        color: Theme.of(context).colorScheme.outline,
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
                  hintText: 'কোর্স সার্চ করুন.....',
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
