import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/timetable.dart';
import '../config/api_config.dart';

class TimeTableService {
  static const String baseUrl = 'https://open.neis.go.kr/hub';
  final http.Client _client = http.Client();

  // API 요청 URL 생성을 위한 별도 메서드
  Uri _buildApiUrl({
    required String grade,
    required String classNum,
    required String date,
  }) {
    return Uri.parse('$baseUrl/hisTimetable').replace(
      queryParameters: {
        'KEY': ApiConfig.neisApiKey,
        'Type': 'json',
        'ATPT_OFCDC_SC_CODE': ApiConfig.officeCode,
        'SD_SCHUL_CODE': ApiConfig.schoolCode,
        'GRADE': grade,
        'CLASS_NM': classNum,
        'TI_FROM_YMD': date,
        'TI_TO_YMD': date,
      },
    );
  }

  // 응답 데이터 파싱을 위한 별도 메서드
  List<String> _parseSubjects(List<dynamic> rows) {
    final subjects = List.filled(7, '', growable: false);
    for (final row in rows) {
      final perio = int.tryParse(row['PERIO']?.toString() ?? '') ?? 0;
      if (perio > 0 && perio <= 7) {
        subjects[perio - 1] = row['ITRT_CNTNT']?.toString() ?? '';
      }
    }
    return subjects;
  }

  Future<TimeTable> fetchTimeTable({
    required String grade,
    required String classNum,
    required String date,
  }) async {
    print('\nNEIS API에서 시간표 데이터 요청 중...');
    try {
      final url = _buildApiUrl(grade: grade, classNum: classNum, date: date);
      print('요청 URL: $url');

      final stopwatch = Stopwatch()..start();
      final response = await _client.get(url);
      stopwatch.stop();
      print('API 응답 시간: ${stopwatch.elapsedMilliseconds}ms');

      if (response.statusCode == 200) {
        print('응답 상태 코드: ${response.statusCode}');

        // 응답 데이터 파싱 시작
        final stopwatchParse = Stopwatch()..start();
        final data = json.decode(response.body);
        final hisTimetable = data['hisTimetable'];

        if (hisTimetable == null || hisTimetable[1]['row'] == null) {
          print('시간표 데이터가 없습니다.');
          return TimeTable.empty();
        }

        final List<dynamic> rows = hisTimetable[1]['row'];
        print('시간표 데이터 ${rows.length}개 수신 성공');

        // 시간표 데이터 변환
        final subjects = _parseSubjects(rows);
        final nonEmptySubjects = subjects.where((s) => s.isNotEmpty).length;

        stopwatchParse.stop();
        print('데이터 파싱 시간: ${stopwatchParse.elapsedMilliseconds}ms');
        print('시간표 데이터 변환 완료: ${nonEmptySubjects}교시');

        return TimeTable(
          grade: grade,
          classNum: classNum,
          subjects: [subjects],
          periods: List.generate(7, (i) => '${i + 1}교시', growable: false),
          weekdays: const ['오늘'],
          startTime: '9:00',
        );
      } else {
        print('API 요청 실패: ${response.statusCode}');
        throw Exception('시간표 데이터를 불러오는데 실패했습니다.');
      }
    } catch (e) {
      print('시간표 데이터 로딩 실패: $e');
      throw Exception('시간표 데이터를 가져오는 중 오류가 발생했습니다: $e');
    }
  }

  void dispose() {
    _client.close();
  }
}
