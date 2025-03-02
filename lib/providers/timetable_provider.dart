import 'package:flutter/material.dart';
import '../models/timetable.dart';
import '../services/timetable_service.dart';
import '../services/timetable_storage_service.dart';

class TimeTableProvider with ChangeNotifier {
  final TimeTableService _timeTableService;
  final TimeTableStorageService _storageService;
  TimeTable? _timeTable;
  bool _isLoading = false;
  bool _isInitialized = false;
  String? _error;
  String? _message;
  DateTime _selectedDate = DateTime.now();
  String _grade = '1';
  String _classNum = '3';

  TimeTableProvider(this._timeTableService, this._storageService) {
    _initializeTimeTable();
  }

  void _initializeTimeTable() async {
    try {
      _isLoading = true;
      _message = '로컬 저장소에서 시간표 데이터를 불러오는 중...';
      notifyListeners();

      // 1. 로컬 저장소에서 데이터 로드
      final localData = await _storageService.getTimeTable();
      if (localData != null) {
        _timeTable = localData;
        _message = '로컬 저장소에서 시간표 데이터 로드 완료';
        print('로컬 데이터 로드: ${localData.subjects.length}교시');
        notifyListeners();
      }

      // 2. 업데이트가 필요한지 확인
      if (await _storageService.needsUpdate()) {
        await fetchTimeTable(forceRefresh: true);
      } else {
        _isLoading = false;
        _isInitialized = true;
        notifyListeners();
      }
    } catch (e) {
      _error = e.toString();
      _message = '시간표 초기화 중 오류가 발생했습니다.';
      _timeTable = TimeTable.empty();
      _isLoading = false;
      notifyListeners();
    }
  }

  TimeTable? get timeTable => _timeTable;
  bool get isLoading => _isLoading;
  bool get isInitialized => _isInitialized;
  String? get error => _error;
  String? get message => _message;
  DateTime get selectedDate => _selectedDate;
  String get grade => _grade;
  String get classNum => _classNum;

  void setDate(DateTime date) {
    if (_selectedDate != date) {
      _selectedDate = date;
      fetchTimeTable(forceRefresh: true);
    }
  }

  void setGrade(String grade) {
    if (_grade != grade) {
      _grade = grade;
      fetchTimeTable(forceRefresh: true);
    }
  }

  void setClassNum(String classNum) {
    if (_classNum != classNum) {
      _classNum = classNum;
      fetchTimeTable(forceRefresh: true);
    }
  }

  void clearError() {
    _error = null;
    _message = null;
    notifyListeners();
  }

  Future<void> fetchTimeTable({bool forceRefresh = false}) async {
    try {
      _isLoading = true;
      _error = null;
      _message = '시간표를 불러오는 중입니다...';
      notifyListeners();

      if (!forceRefresh) {
        // 1. 로컬에서 데이터 먼저 로드
        final localData = await _storageService.getTimeTable();
        if (localData != null) {
          _timeTable = localData;
          _message = '로컬 저장소에서 시간표를 불러왔습니다.';
          notifyListeners();

          // 업데이트가 필요없다면 여기서 종료
          if (!await _storageService.needsUpdate()) {
            _isLoading = false;
            _isInitialized = true;
            return;
          }
        }
      }

      // 2. API에서 새로운 데이터 가져오기
      _message = 'NEIS API에서 시간표를 가져오는 중...';
      notifyListeners();

      final date = _selectedDate
          .toString()
          .replaceAll(RegExp(r'[^0-9]'), '')
          .substring(0, 8);
      final newTimeTable = await _timeTableService.fetchTimeTable(
        date: date,
        grade: _grade,
        classNum: _classNum,
      );

      // 3. 로컬 저장소에 저장
      _message = '시간표를 저장하는 중...';
      notifyListeners();
      await _storageService.saveTimeTable(newTimeTable);

      // 4. 상태 업데이트
      _timeTable = newTimeTable;
      _isInitialized = true;
      _message = '시간표를 성공적으로 불러왔습니다.';
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _message = '시간표를 불러오는데 실패했습니다.';
      notifyListeners();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> clearTimeTable() async {
    await _storageService.clearTimeTable();
    _timeTable = null;
    notifyListeners();
  }
}
