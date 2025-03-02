import 'package:flutter/material.dart';
import '../models/timetable.dart';
import '../services/timetable_service.dart';
import '../widgets/timetable_widget.dart';

class TimeTableScreen extends StatefulWidget {
  const TimeTableScreen({Key? key}) : super(key: key);

  @override
  State<TimeTableScreen> createState() => _TimeTableScreenState();
}

class _TimeTableScreenState extends State<TimeTableScreen> {
  final _timeTableService = TimeTableService();
  TimeTable? _timeTable;
  bool _isLoading = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    // 초기 빈 시간표 생성
    _timeTable = TimeTable(
      grade: '1',
      classNum: '3',
      subjects: [List.generate(7, (index) => '')],
      periods: List.generate(7, (i) => '${i + 1}교시'),
      weekdays: ['오늘'],
      startTime: '9:00',
    );
  }

  Future<void> _fetchTimeTable() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final timeTable = await _timeTableService.fetchTimeTable(
        grade: '1',
        classNum: '3',
        date: '20240304',
      );

      setState(() {
        _timeTable = timeTable;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('시간표'),
      ),
      body: Column(
        children: [
          // 시간표 위젯
          if (_timeTable != null)
            Expanded(
              child: SingleChildScrollView(
                child: TimeTableWidget(timeTable: _timeTable!),
              ),
            ),

          // 로딩 인디케이터
          if (_isLoading) const Center(child: CircularProgressIndicator()),

          // 에러 메시지
          if (_error != null)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                _error!,
                style: const TextStyle(color: Colors.red),
              ),
            ),

          // 데이터 가져오기 버튼
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: _isLoading ? null : _fetchTimeTable,
              child: const Text('시간표 가져오기'),
            ),
          ),
        ],
      ),
    );
  }
}
