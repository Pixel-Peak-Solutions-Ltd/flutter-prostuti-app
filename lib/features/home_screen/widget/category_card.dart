import 'package:flutter/material.dart';

class CategoryCard extends StatefulWidget {
  final String icon;
  final String image;
  final String text;

  const CategoryCard(
      {super.key, required this.icon, required this.text, required this.image});

  @override
  State<CategoryCard> createState() => _CategoryCardState();
}

class _CategoryCardState extends State<CategoryCard> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Container(
      width: 170,
      height: 170,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(widget.image.toString()),
          fit: BoxFit.cover,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(widget.icon.toString(), height: 60, width: 60),
          const SizedBox(height: 8),
          Text(
            widget.text,
            style: const TextStyle(color: Colors.white, fontSize: 16),
          ),
        ],
      ),
    );
  }
}
