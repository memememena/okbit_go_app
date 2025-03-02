import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/timetable.dart';

class TimeTableStorageService {
  static const String _timeTableKey = 'timetable_data';
  static const String _lastUpdateKey = 'timetable_last_update';

  final SharedPreferences _prefs;

  TimeTableStorageService(this._prefs);

  static Future<TimeTableStorageService> create() async {
    final prefs = await SharedPreferences.getInstance();
    return TimeTableStorageService(prefs);
  }

  // 시간표 데이터 저장
  Future<void> saveTimeTable(TimeTable timeTable) async {
    print('\n시간표 데이터 로컬 저장소에 저장 중...');
    try {
      final jsonData = jsonEncode(timeTable.toJson());
      await _prefs.setString(_timeTableKey, jsonData);
      await _prefs.setString(_lastUpdateKey, DateTime.now().toIso8601String());
      print('시간표 데이터 저장 성공!');
    } catch (e) {
      print('시간표 데이터 저장 실패: $e');
      throw Exception('시간표 데이터 저장 실패: $e');
    }
  }

  // 저장된 시간표 데이터 가져오기
  Future<TimeTable?> getTimeTable() async {
    print('\n로컬 저장소에서 시간표 데이터 로드 중...');
    try {
      final String? jsonData = _prefs.getString(_timeTableKey);
      if (jsonData != null) {
        final data = jsonDecode(jsonData);
        final timeTable = TimeTable.fromJson(data);
        print('로컬 저장소에서 시간표 데이터 로드 성공!');
        print('시간표 데이터: ${timeTable.subjects.length}교시');
        return timeTable;
      }
      print('로컬 저장소에 시간표 데이터가 없습니다.');
      return null;
    } catch (e) {
      print('로컬 저장소에서 시간표 데이터 로드 실패: $e');
      return null;
    }
  }

  // 마지막 업데이트 시간 확인
  Future<DateTime?> getLastUpdateTime() async {
    final lastUpdate = _prefs.getString(_lastUpdateKey);
    return lastUpdate != null ? DateTime.parse(lastUpdate) : null;
  }

  // 업데이트가 필요한지 확인 (일주일에 한 번)
  Future<bool> needsUpdate() async {
    final lastUpdate = await getLastUpdateTime();
    if (lastUpdate == null) {
      print('마지막 업데이트 정보 없음, 업데이트 필요');
      return true;
    }

    final now = DateTime.now();
    final difference = now.difference(lastUpdate);

    // 하루가 지났거나 다른 날짜인 경우 업데이트
    if (difference.inDays > 0 ||
        lastUpdate.day != now.day ||
        lastUpdate.month != now.month ||
        lastUpdate.year != now.year) {
      print('마지막 업데이트로부터 ${difference.inHours}시간 경과, 업데이트 필요');
      return true;
    }

    print('최신 데이터 사용 가능 (마지막 업데이트: ${difference.inHours}시간 전)');
    return false;
  }

  // 저장된 데이터 삭제
  Future<void> clearTimeTable() async {
    print('\n시간표 데이터 삭제 중...');
    try {
      await _prefs.remove(_timeTableKey);
      await _prefs.remove(_lastUpdateKey);
      print('시간표 데이터 삭제 완료');
    } catch (e) {
      print('시간표 데이터 삭제 실패: $e');
      throw Exception('시간표 데이터 삭제 실패: $e');
    }
  }
}
