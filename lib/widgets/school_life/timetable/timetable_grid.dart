import 'package:flutter/material.dart';
import '../../../utils/constants.dart';
import '../../../models/timetable.dart';

class TimeTableGrid extends StatelessWidget {
  final TimeTable timeTable;

  const TimeTableGrid({
    Key? key,
    required this.timeTable,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: kSurfaceColor,
        border: Border.all(color: kBorderColor),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final cellWidth =
              (constraints.maxWidth - 60) / timeTable.weekdays.length;
          final cellHeight = 64.0;

          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildHeader(cellWidth),
              Column(
                children: List.generate(
                  timeTable.subjects.length,
                  (periodIndex) =>
                      _buildRow(periodIndex, cellWidth, cellHeight),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildHeader(double cellWidth) {
    return Container(
      height: 52,
      decoration: const BoxDecoration(
        color: Color(0xFF2A2A2A),
        border: Border(bottom: BorderSide(color: kBorderColor)),
      ),
      child: Row(
        children: [
          _buildHeaderCell('교시', width: 60, isFirst: true),
          ...List.generate(timeTable.weekdays.length, (dayIndex) {
            return _buildHeaderCell(
              timeTable.weekdays[dayIndex],
              width: cellWidth,
            );
          }),
        ],
      ),
    );
  }

  Widget _buildRow(int periodIndex, double cellWidth, double cellHeight) {
    return Container(
      height: cellHeight,
      decoration: BoxDecoration(
        border: Border(
          bottom: periodIndex < timeTable.subjects.length - 1
              ? const BorderSide(color: kBorderColor)
              : BorderSide.none,
        ),
      ),
      child: Row(
        children: [
          _buildCell(
            timeTable.periods[periodIndex],
            width: 60,
            height: cellHeight,
            isFirst: true,
            isHeader: true,
          ),
          ...List.generate(timeTable.weekdays.length, (dayIndex) {
            final subject = timeTable.subjects[periodIndex][dayIndex];
            return _buildCell(
              subject,
              width: cellWidth,
              height: cellHeight,
            );
          }),
        ],
      ),
    );
  }

  Widget _buildHeaderCell(
    String text, {
    required double width,
    bool isFirst = false,
  }) {
    return Container(
      width: width,
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        border: Border(
          left: !isFirst
              ? const BorderSide(color: kBorderColor)
              : BorderSide.none,
        ),
      ),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 15,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildCell(
    String text, {
    required double width,
    required double height,
    bool isFirst = false,
    bool isHeader = false,
  }) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: isHeader ? const Color(0xFF2A2A2A) : null,
        border: Border(
          left: !isFirst
              ? const BorderSide(color: kBorderColor)
              : BorderSide.none,
        ),
      ),
      child: Center(
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: isHeader ? Colors.white : Colors.grey[300],
            fontSize: 14,
            fontWeight: isHeader ? FontWeight.w600 : FontWeight.w400,
          ),
        ),
      ),
    );
  }
}
