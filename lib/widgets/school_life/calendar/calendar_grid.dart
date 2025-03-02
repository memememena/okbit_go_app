import 'package:flutter/material.dart';
import '../../../utils/constants.dart';
import '../../../models/event.dart';

class CalendarGrid extends StatelessWidget {
  final DateTime focusedDay;
  final DateTime selectedDay;
  final Map<DateTime, List<Event>> events;
  final Function(DateTime) onDaySelected;

  const CalendarGrid({
    Key? key,
    required this.focusedDay,
    required this.selectedDay,
    required this.events,
    required this.onDaySelected,
  }) : super(key: key);

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  @override
  Widget build(BuildContext context) {
    final daysInMonth = DateTime(focusedDay.year, focusedDay.month + 1, 0).day;
    final firstDayOfMonth = DateTime(focusedDay.year, focusedDay.month, 1);
    final firstWeekday = firstDayOfMonth.weekday;
    final prevMonthDays = (firstWeekday == 7 ? 0 : firstWeekday);
    final totalDays = prevMonthDays + daysInMonth;
    final totalWeeks = ((totalDays + 6) ~/ 7);
    const cellHeight = 75.0;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border.all(color: kBorderColor),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: List.generate(totalWeeks, (weekIndex) {
          return Row(
            children: List.generate(7, (dayIndex) {
              final index = weekIndex * 7 + dayIndex;
              final dayNumber = index - prevMonthDays + 1;

              if (index < prevMonthDays || dayNumber > daysInMonth) {
                return Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border(
                        right: dayIndex < 6
                            ? const BorderSide(color: kBorderColor)
                            : BorderSide.none,
                        bottom: weekIndex < totalWeeks - 1
                            ? const BorderSide(color: kBorderColor)
                            : BorderSide.none,
                      ),
                    ),
                    height: cellHeight,
                  ),
                );
              }

              final date = DateTime(
                focusedDay.year,
                focusedDay.month,
                dayNumber,
              );
              final isToday = _isSameDay(date, DateTime.now());
              final isSelected = _isSameDay(date, selectedDay);
              final hasEvents = events[date]?.isNotEmpty ?? false;

              Color textColor;
              if (dayIndex == 0) {
                textColor = Colors.red[300]!;
              } else if (dayIndex == 6) {
                textColor = Colors.blue[300]!;
              } else {
                textColor = Colors.white;
              }

              return Expanded(
                child: GestureDetector(
                  onTap: () => onDaySelected(date),
                  child: Container(
                    height: cellHeight,
                    decoration: BoxDecoration(
                      color: isSelected
                          ? Colors.blue[400]!.withOpacity(0.15)
                          : Colors.transparent,
                      border: Border(
                        right: dayIndex < 6
                            ? const BorderSide(color: kBorderColor)
                            : BorderSide.none,
                        bottom: weekIndex < totalWeeks - 1
                            ? const BorderSide(color: kBorderColor)
                            : BorderSide.none,
                      ),
                    ),
                    child: Stack(
                      children: [
                        if (isToday)
                          Positioned(
                            left: 0,
                            right: 0,
                            bottom: 0,
                            child: Container(
                              height: 2,
                              color: Colors.blue[400],
                            ),
                          ),
                        Center(
                          child: Text(
                            dayNumber.toString(),
                            style: TextStyle(
                              color: textColor,
                              fontSize: 18,
                              fontWeight: (isToday || isSelected)
                                  ? FontWeight.w600
                                  : FontWeight.w400,
                            ),
                          ),
                        ),
                        if (hasEvents)
                          Positioned(
                            bottom: 12,
                            left: 0,
                            right: 0,
                            child: Center(
                              child: Container(
                                width: 5,
                                height: 5,
                                decoration: BoxDecoration(
                                  color: Colors.blue[400],
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              );
            }),
          );
        }),
      ),
    );
  }
}
