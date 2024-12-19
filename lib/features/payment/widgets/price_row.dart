import 'package:flutter/material.dart';

class PriceRow extends StatelessWidget {
  final String price, name;

  const PriceRow({super.key, required this.price, required this.name});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(name, style: Theme.of(context).textTheme.bodyMedium),
        Text(
          "৳ $price",
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ],
    );
  }
}
