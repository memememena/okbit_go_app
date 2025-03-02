import 'package:flutter/material.dart';
import 'allergy_chip.dart';

class AllergySection extends StatelessWidget {
  final String title;
  final List<String> items;
  final Color color;

  const AllergySection({
    Key? key,
    required this.title,
    required this.items,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: color.withOpacity(0.2),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            title,
            style: TextStyle(
              color: color,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: items.map((item) => AllergyChip(label: item)).toList(),
        ),
      ],
    );
  }
}
