import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:okbit_go_app/utils/constants.dart';
import '../../../models/meal.dart';

class MealListItem extends StatelessWidget {
  final Meal meal;

  const MealListItem({
    Key? key,
    required this.meal,
  }) : super(key: key);

  String _formatDate(String date) {
    final parsedDate = DateTime.parse(
      '${date.substring(0, 4)}-${date.substring(4, 6)}-${date.substring(6, 8)}',
    );
    return DateFormat('M월 d일 (E)', kLocale).format(parsedDate);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(kSpacing),
      decoration: BoxDecoration(
        color: kSurfaceColor,
        borderRadius: BorderRadius.circular(kBorderRadius),
        border: Border.all(color: kBorderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                _formatDate(meal.date),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                meal.calorie,
                style: TextStyle(
                  color: Colors.grey[400],
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: kSmallSpacing),
          Text(
            meal.menu.join(', '),
            style: TextStyle(
              color: Colors.grey[300],
              fontSize: 14,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
