import 'package:flutter/material.dart';
import '../../../utils/constants.dart';

class AllergyChip extends StatelessWidget {
  final String label;

  const AllergyChip({
    Key? key,
    required this.label,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: kBorderColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFF333333)),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 13,
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }
}
