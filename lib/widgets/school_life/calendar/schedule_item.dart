import 'package:flutter/material.dart';

class ScheduleItem extends StatelessWidget {
  final String description;
  final String title;
  final bool isToday;

  const ScheduleItem({
    Key? key,
    required this.description,
    required this.title,
    required this.isToday,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 3,
          height: 36,
          decoration: BoxDecoration(
            color: isToday ? Colors.blue[400] : Colors.transparent,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                description,
                style: TextStyle(
                  color: Colors.grey[500],
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
