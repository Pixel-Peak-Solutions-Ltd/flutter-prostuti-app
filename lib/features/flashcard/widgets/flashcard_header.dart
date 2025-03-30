import 'package:flutter/material.dart';

class FlashcardHeader extends StatelessWidget {
  const FlashcardHeader({
    super.key,
    required this.text,
  });

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: Theme.of(context)
          .textTheme
          .titleMedium!
          .copyWith(fontWeight: FontWeight.w700),
    );
  }
}
