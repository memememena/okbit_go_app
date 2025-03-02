import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../utils/constants.dart';

class CalendarHeader extends StatelessWidget {
  final DateTime focusedDay;
  final VoidCallback onPreviousMonth;
  final VoidCallback onNextMonth;

  const CalendarHeader({
    Key? key,
    required this.focusedDay,
    required this.onPreviousMonth,
    required this.onNextMonth,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          onPressed: onPreviousMonth,
          icon: const Icon(Icons.chevron_left, color: Colors.white),
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
        ),
        Text(
          DateFormat('yyyy년 M월', kLocale).format(focusedDay),
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        IconButton(
          onPressed: onNextMonth,
          icon: const Icon(Icons.chevron_right, color: Colors.white),
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
        ),
      ],
    );
  }
}
