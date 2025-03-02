class TimeTable {
  final String grade;
  final String classNum;
  final List<List<String>> subjects;
  final List<String> periods;
  final List<String> weekdays;
  final String startTime;
  final String period;

  String get className => '$grade학년 $classNum반';

  TimeTable({
    required this.grade,
    required this.classNum,
    required this.subjects,
    required this.periods,
    required this.weekdays,
    this.startTime = '09:00',
    this.period = '',
  });

  factory TimeTable.fromJson(Map<String, dynamic> json) {
    return TimeTable(
      grade: json['grade'] as String,
      classNum: json['classNum'] as String,
      subjects: List<List<String>>.from(
        json['subjects'].map((x) => List<String>.from(x)),
      ),
      periods: List<String>.from(json['periods']),
      weekdays: List<String>.from(json['weekdays']),
    );
  }

  Map<String, dynamic> toJson() => {
        'grade': grade,
        'classNum': classNum,
        'subjects': subjects,
        'periods': periods,
        'weekdays': weekdays,
      };

  factory TimeTable.empty() {
    return TimeTable(
      grade: '1',
      classNum: '1',
      subjects: List.generate(7, (_) => List.filled(5, '')),
      periods: List.generate(7, (i) => '${i + 1}교시'),
      weekdays: ['월', '화', '수', '목', '금'],
    );
  }

  factory TimeTable.sample() {
    return TimeTable(
      grade: '1',
      classNum: '3',
      subjects: [
        ['국어', '수학', '영어', '과학', '체육'],
        ['수학', '영어', '국어', '음악', '미술'],
        ['영어', '과학', '체육', '국어', '수학'],
        ['과학', '체육', '미술', '수학', '영어'],
        ['체육', '국어', '수학', '영어', '과학'],
        ['음악', '미술', '과학', '체육', '국어'],
        ['미술', '음악', '체육', '과학', '수학'],
      ],
      periods: List.generate(7, (i) => '${i + 1}교시'),
      weekdays: ['월', '화', '수', '목', '금'],
    );
  }
}

class Period {
  final List<String> subjects;

  Period({required this.subjects});

  factory Period.fromJson(Map<String, dynamic> json) {
    final List<dynamic> subjectsJson = json['subjects'];
    final subjects = subjectsJson.map((s) => s.toString()).toList();
    return Period(subjects: subjects);
  }
}
