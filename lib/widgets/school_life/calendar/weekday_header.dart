import 'package:flutter/material.dart';

class WeekdayHeader extends StatelessWidget {
  const WeekdayHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final weekdays = ['일', '월', '화', '수', '목', '금', '토'];
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: weekdays.map((day) {
        Color color;
        if (day == '일') {
          color = Colors.red[300]!;
        } else if (day == '토') {
          color = Colors.blue[300]!;
        } else {
          color = Colors.grey[500]!;
        }
        return SizedBox(
          width: 30,
          child: Center(
            child: Text(
              day,
              style: TextStyle(
                color: color,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
