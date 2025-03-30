import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class FlashcardSearchContainer extends StatefulWidget {
  final TextEditingController controller;
  final Function(String) onChanged;

  const FlashcardSearchContainer({
    super.key,
    required this.controller,
    required this.onChanged,
  });

  @override
  State<FlashcardSearchContainer> createState() =>
      _FlashcardSearchContainerState();
}

class _FlashcardSearchContainerState extends State<FlashcardSearchContainer> {
  final FocusNode _focusNode = FocusNode();
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      setState(() {
        _isFocused = _focusNode.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      decoration: BoxDecoration(
        border: Border.all(
          width: 0.8,
          color: _isFocused ? const Color(0xff2970FF) : Colors.grey,
        ),
        borderRadius: BorderRadius.circular(16),
        color: Theme.of(context).scaffoldBackgroundColor,
        // Add a subtle shadow when focused
        boxShadow: _isFocused
            ? [
                BoxShadow(
                  color: const Color(0xff2970FF).withOpacity(0.1),
                  blurRadius: 4,
                  spreadRadius: 1,
                )
              ]
            : null,
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: widget.controller,
                focusNode: _focusNode,
                textInputAction: TextInputAction.search,
                decoration: InputDecoration(
                  hintText: 'ফ্লাশকার্ড সার্চ করুন.....',
                  hintStyle: Theme.of(context).textTheme.bodyLarge,
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  disabledBorder: InputBorder.none,
                  isDense: true,
                  contentPadding: EdgeInsets.zero,
                ),
                onChanged: widget.onChanged,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SvgPicture.asset(
                'assets/icons/search_icon.svg',
                fit: BoxFit.cover,
                // Change color when focused
                color: _isFocused ? const Color(0xff2970FF) : null,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
