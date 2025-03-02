import 'package:flutter/material.dart';
import '../models/meal.dart';
import '../services/meal_service.dart';
import '../services/meal_storage_service.dart';

class MealProvider with ChangeNotifier {
  final MealService _mealService;
  final MealStorageService _storageService;
  List<Meal> _meals = [];
  bool _isLoading = false;
  bool _isInitialized = false;
  String? _error;
  DateTime _selectedDate = DateTime.now();

  MealProvider(this._mealService, this._storageService) {
    _initializeMeals();
  }

  List<Meal> get meals => _meals;
  bool get isLoading => _isLoading;
  bool get isInitialized => _isInitialized;
  String? get error => _error;
  DateTime get selectedDate => _selectedDate;

  void setDate(DateTime date) {
    _selectedDate = date;
    notifyListeners();
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }

  Future<void> _initializeMeals() async {
    await fetchMeals();
  }

  Future<void> fetchMeals({bool forceRefresh = false}) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      // 1. 로컬에서 데이터 먼저 로드
      List<Meal> localMeals = [];
      try {
        localMeals = await _storageService.getMeals();
        print('로컬 데이터 로드: ${localMeals.length}개');
      } catch (e) {
        print('로컬 데이터 로드 실패: $e');
      }

      if (localMeals.isNotEmpty) {
        _meals = localMeals;
        _isInitialized = true;
        notifyListeners();
      }

      // 2. 업데이트가 필요한지 확인
      if (forceRefresh ||
          await _storageService.needsUpdate() ||
          localMeals.isEmpty) {
        // 3. API에서 새로운 데이터 가져오기
        final now = DateTime.now();
        final date = '${now.year}${now.month.toString().padLeft(2, '0')}';

        try {
          final newMeals = await _mealService.fetchMeals(date: date);
          print('API 데이터 로드: ${newMeals.length}개');

          if (newMeals.isNotEmpty) {
            // 4. 로컬 저장소에 저장
            await _storageService.saveMeals(newMeals);
            _meals = newMeals;
            _isInitialized = true;
            _error = null;
          } else {
            _error = '이번 달 급식 데이터가 없습니다.';
          }
        } catch (e) {
          print('API 데이터 로드 실패: $e');
          if (localMeals.isEmpty) {
            _error = '급식 데이터를 불러오는데 실패했습니다.';
          }
        }
      }
    } catch (e) {
      print('급식 데이터 처리 중 오류 발생: $e');
      _error = '급식 데이터를 불러오는데 실패했습니다.';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> clearMeals() async {
    try {
      _isLoading = true;
      notifyListeners();

      await _storageService.clearMeals();
      _meals = [];
      _isInitialized = false;
      _error = null;
      notifyListeners();

      // 캐시 삭제 후 데이터 다시 불러오기
      await fetchMeals(forceRefresh: true);
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // 특정 날짜의 급식 데이터 가져오기
  Meal? getMealForDate(String date) {
    return _meals.firstWhere(
      (meal) => meal.date == date,
      orElse: () => Meal(
        date: date,
        calorie: '',
        menu: [],
      ),
    );
  }
}
