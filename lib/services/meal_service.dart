import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/meal.dart';
import '../config/api_config.dart';

class MealService {
  static const String baseUrl = 'https://open.neis.go.kr/hub';
  final http.Client _client = http.Client();

  // 메뉴 텍스트 정리를 위한 메서드
  String _cleanMenuText(String text) {
    return text
        .replaceAll(RegExp(r'\[.*?\]'), '') // 대괄호와 그 안의 내용 제거
        .replaceAll(RegExp(r'\s+'), ' ') // 연속된 공백을 하나로
        .trim(); // 앞뒤 공백 제거
  }

  Future<List<Meal>> fetchMeals({
    required String date, // YYYYMM 형식
  }) async {
    print('\n급식 데이터 요청 중...');
    try {
      // 날짜 형식 변환 (YYYYMM -> YYYYMM01, YYYYMM31)
      final fromDate = '${date}01'; // 월의 첫날
      final toDate = '${date}31'; // 월의 마지막날

      final url = Uri.parse('$baseUrl/mealServiceDietInfo').replace(
        queryParameters: {
          'KEY': ApiConfig.neisApiKey,
          'Type': 'json',
          'ATPT_OFCDC_SC_CODE': ApiConfig.officeCode,
          'SD_SCHUL_CODE': ApiConfig.schoolCode,
          'MLSV_FROM_YMD': fromDate,
          'MLSV_TO_YMD': toDate,
        },
      );

      print('요청 URL: $url');

      final response = await _client.get(url);
      print('응답 상태 코드: ${response.statusCode}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final mealServiceDietInfo = data['mealServiceDietInfo'];

        if (mealServiceDietInfo == null) {
          print('급식 데이터가 없습니다. (mealServiceDietInfo is null)');
          return [];
        }

        if (mealServiceDietInfo is List && mealServiceDietInfo.length > 1) {
          final rowData = mealServiceDietInfo[1];
          if (rowData is Map<String, dynamic> && rowData['row'] != null) {
            final List<dynamic> rows = rowData['row'];
            print('급식 데이터 ${rows.length}개 수신');

            final meals = rows.map((row) {
              if (row['DDISH_NM'] != null) {
                row['DDISH_NM'] = _cleanMenuText(row['DDISH_NM'].toString());
              }
              return Meal.fromJson(row as Map<String, dynamic>);
            }).toList();

            // 날짜순으로 정렬
            meals.sort((a, b) => a.date.compareTo(b.date));
            print('급식 데이터 변환 완료: ${meals.length}개');
            return meals;
          }
        }

        print('급식 데이터 형식이 올바르지 않습니다.');
        return [];
      } else {
        print('API 요청 실패: ${response.statusCode}');
        throw Exception('Failed to load meals: ${response.statusCode}');
      }
    } catch (e) {
      print('급식 데이터 로딩 실패: $e');
      throw Exception('Failed to fetch meals: $e');
    }
  }

  void dispose() {
    _client.close();
  }
}
