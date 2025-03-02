import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/meal.dart';

class MealStorageService {
  static const String _mealKey = 'meal_data';
  static const String _lastUpdateKey = 'meal_last_update';

  final SharedPreferences _prefs;

  MealStorageService(this._prefs);

  static Future<MealStorageService> create() async {
    final prefs = await SharedPreferences.getInstance();
    return MealStorageService(prefs);
  }

  // 메뉴 텍스트 정리를 위한 메서드
  String _cleanMenuText(String text) {
    return text
        .replaceAll(RegExp(r'\[.*?\]'), '') // 대괄호와 그 안의 내용 제거
        .replaceAll(RegExp(r'\s+'), ' ') // 연속된 공백을 하나로
        .trim(); // 앞뒤 공백 제거
  }

  Future<void> saveMeals(List<Meal> meals) async {
    try {
      print('\n로컬 저장소에 급식 데이터 저장 중...');
      final mealJsonList = meals
          .map((meal) => {
                'date': meal.date,
                'calorie': meal.calorie,
                'menu': meal.menu.map(_cleanMenuText).join('\n'),
              })
          .toList();

      final jsonString = jsonEncode(mealJsonList);
      final success = await _prefs.setString(_mealKey, jsonString);
      if (success) {
        await _prefs.setString(
            _lastUpdateKey, DateTime.now().toIso8601String());
        print('급식 데이터 저장 성공! (${meals.length}개)');
      } else {
        print('급식 데이터 저장 실패');
      }
    } catch (e) {
      print('급식 데이터 저장 중 오류 발생: $e');
      rethrow;
    }
  }

  Future<List<Meal>> getMeals() async {
    try {
      print('\n로컬 저장소에서 급식 데이터 로드 중...');
      final mealJsonString = _prefs.getString(_mealKey);
      if (mealJsonString == null) {
        print('저장된 급식 데이터가 없습니다.');
        return [];
      }

      final mealJsonList = jsonDecode(mealJsonString) as List;
      final meals = mealJsonList
          .map((json) {
            try {
              final date = json['date']?.toString() ?? '';
              final calorie = json['calorie']?.toString() ?? '';
              final menuStr = json['menu']?.toString() ?? '';

              if (date.isEmpty) {
                print('날짜 데이터가 없습니다: $json');
                return null;
              }

              final menuList = menuStr.isEmpty
                  ? <String>[]
                  : menuStr
                      .split('\n')
                      .map(_cleanMenuText)
                      .where((item) => item.isNotEmpty)
                      .toList();

              return Meal(
                date: date,
                calorie: calorie,
                menu: menuList,
              );
            } catch (e) {
              print('급식 데이터 파싱 오류: $e\n데이터: $json');
              return null;
            }
          })
          .whereType<Meal>()
          .toList();

      print('로컬 저장소에서 급식 데이터 로드 성공! (${meals.length}개)');
      return meals;
    } catch (e) {
      print('로컬 저장소에서 급식 데이터 로드 중 오류 발생: $e');
      return [];
    }
  }

  Future<DateTime?> getLastUpdateTime() async {
    try {
      final lastUpdate = _prefs.getString(_lastUpdateKey);
      return lastUpdate != null ? DateTime.parse(lastUpdate) : null;
    } catch (e) {
      print('마지막 업데이트 시간 확인 중 오류 발생: $e');
      return null;
    }
  }

  Future<bool> needsUpdate() async {
    try {
      final lastUpdate = await getLastUpdateTime();
      if (lastUpdate == null) {
        print('첫 데이터 로드 필요');
        return true;
      }

      final now = DateTime.now();
      final needsUpdate = now.difference(lastUpdate).inHours >= 24;
      print(needsUpdate ? '데이터 업데이트 필요' : '최신 데이터 사용 가능');
      return needsUpdate;
    } catch (e) {
      print('업데이트 필요 여부 확인 중 오류 발생: $e');
      return true;
    }
  }

  Future<void> clearMeals() async {
    try {
      print('\n로컬 저장소의 급식 데이터 삭제 중...');
      await _prefs.remove(_mealKey);
      await _prefs.remove(_lastUpdateKey);
      print('급식 데이터 삭제 완료');
    } catch (e) {
      print('급식 데이터 삭제 중 오류 발생: $e');
      rethrow;
    }
  }
}
