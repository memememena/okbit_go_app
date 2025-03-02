import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';

class SchoolInfoService {
  static const String baseUrl = 'https://open.neis.go.kr/hub';

  Future<void> searchSchool(String schoolName) async {
    try {
      final url = Uri.parse('$baseUrl/schoolInfo'
          '?KEY=${ApiConfig.neisApiKey}'
          '&Type=json'
          '&ATPT_OFCDC_SC_CODE=J10' // 경기도교육청 코드
          '&SCHUL_NM=${Uri.encodeComponent("옥빛")}' // 학교 이름으로 검색
          '&pSize=100');

      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final schoolInfo = data['schoolInfo'];

        if (schoolInfo != null && schoolInfo[1]['row'] != null) {
          final List<dynamic> rows = schoolInfo[1]['row'];
          print('\n=== 검색 결과 ===\n');
          for (var row in rows) {
            print('학교명: ${row['SCHUL_NM']}');
            print('시도교육청코드: ${row['ATPT_OFCDC_SC_CODE']}');
            print('표준학교코드: ${row['SD_SCHUL_CODE']}');
            print('주소: ${row['ORG_RDNMA']}');
            print('설립구분: ${row['FOND_SC_NM']}');
            print('---');
          }
        } else {
          print('검색된 학교가 없습니다.');
          print('참고: 경기도교육청(J10) 관할 학교만 검색됩니다.');
        }
      }
    } catch (e) {
      print('학교 검색 중 오류 발생: $e');
    }
  }
}
