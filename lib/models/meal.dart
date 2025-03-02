class Meal {
  final String date;
  final String calorie;
  final List<String> menu;

  Meal({
    required this.date,
    required this.calorie,
    required this.menu,
  });

  // 칼로리 문자열에서 숫자만 추출하는 메서드
  static String _extractCalorieNumber(String text) {
    // 숫자만 추출
    final numberMatch = RegExp(r'\d+').firstMatch(text);
    return numberMatch?.group(0) ?? '0';
  }

  factory Meal.fromJson(Map<String, dynamic> json) {
    // NEIS API 응답 형식에 맞춰 키 이름 매핑
    final date = json['MLSV_YMD']?.toString() ?? '';

    // 칼로리 정보 처리 (숫자만 추출 후 형식화)
    final rawCalorie = json['CAL_INFO']?.toString() ?? '0';
    final calorieNumber = _extractCalorieNumber(rawCalorie);

    final menuStr = json['DDISH_NM']?.toString() ?? '';

    // 메뉴 문자열을 리스트로 변환
    final menuList = menuStr.isEmpty
        ? <String>[]
        : menuStr
            .split('<br/>')
            .where((item) => item.trim().isNotEmpty)
            .map((item) => item.trim())
            .toList();

    return Meal(
      date: date,
      calorie: '$calorieNumber Kcal',
      menu: menuList,
    );
  }

  Map<String, dynamic> toJson() => {
        'date': date,
        'calorie': calorie,
        'menu': menu.join('\n'),
      };

  @override
  String toString() {
    return 'Meal{date: $date, calorie: $calorie, menu: $menu}';
  }
}
