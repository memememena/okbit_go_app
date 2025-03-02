import 'package:flutter/material.dart';
import '../models/timetable.dart';

class TimeTableWidget extends StatelessWidget {
  final TimeTable timeTable;

  const TimeTableWidget({
    Key? key,
    required this.timeTable,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // 학급 정보와 날짜
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Text(
                timeTable.className,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                timeTable.period,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
        // 시간표 그리드
        Container(
          margin: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey[300]!),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            children: [
              // 교시 헤더
              Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.blue[100],
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(8),
                    topRight: Radius.circular(8),
                  ),
                ),
                child: const Center(
                  child: Text(
                    '교시',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              // 교시별 과목
              ...List.generate(7, (index) {
                final period = index + 1;
                final subject = timeTable.subjects[0][index];

                return Container(
                  decoration: BoxDecoration(
                    border: Border(
                      top: BorderSide(color: Colors.grey[300]!),
                    ),
                  ),
                  child: Row(
                    children: [
                      // 교시 번호
                      Container(
                        width: 50,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        decoration: BoxDecoration(
                          border: Border(
                            right: BorderSide(color: Colors.grey[300]!),
                          ),
                          color: Colors.grey[50],
                        ),
                        child: Center(
                          child: Text(
                            '$period',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      // 과목명
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          child: Center(
                            child: Text(
                              subject.isEmpty ? '-' : subject,
                              style: TextStyle(
                                color: subject.isEmpty
                                    ? Colors.grey
                                    : Colors.black,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ],
          ),
        ),
      ],
    );
  }
}
