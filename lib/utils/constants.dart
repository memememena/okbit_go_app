import 'package:flutter/material.dart';

// App Constants
const kLocale = 'ko_KR';

// Colors
const kBackgroundColor = Color(0xFF121212);
const kSurfaceColor = Color(0xFF1E1E1E);
const kBorderColor = Color(0xFF2A2A2A);

// Text Styles
const kTitleStyle = TextStyle(
  color: Colors.white,
  fontSize: 16,
  fontWeight: FontWeight.w600,
);

const kTabStyle = TextStyle(
  fontSize: 14,
  fontWeight: FontWeight.w600,
);

const kUnselectedTabStyle = TextStyle(
  fontSize: 14,
  fontWeight: FontWeight.w500,
);

// UI Constants
const kSpacing = 16.0;
const kSmallSpacing = 8.0;
const kBorderRadius = 12.0;
const kIconSize = 20.0;

// Error Messages
const kLoadFailedMessage = '데이터를 불러오는데 실패했습니다.';
const kNoDataMessage = '데이터가 없습니다.';
const kRetryButtonText = '다시 시도';
const kRefreshButtonText = '새로고침';

// Dialog Constants
const kDialogMaxHeightFactor = 0.8;
const kDialogPadding = 20.0;
const kDialogIconSize = 24.0;
const kDialogTitleSize = 18.0;

// Screen Titles
const kSchoolLifeTitle = '학교생활';

// Allergy Categories
const kAllergyCategories = {
  '해산물': ['7.고등어', '8.게', '9.새우', '17.오징어', '18.조개류'],
  '육류': ['10.돼지고기', '15.닭고기', '16.쇠고기'],
  '곡류': ['3.메밀', '6.밀'],
  '견과류': ['4.땅콩', '14.호두', '19.잣'],
  '기타': ['1.난류', '2.우유', '5.대두', '11.복숭아', '12.토마토', '13.아황산류'],
};

const kAllergyCategoryColors = {
  '해산물': Colors.blue,
  '육류': Colors.red,
  '곡류': Colors.amber,
  '견과류': Colors.brown,
  '기타': Colors.green,
};

class Assets {
  static const String logo = 'assets/images/logo.jpeg';
}

class Constants {
  static const String emailLabel = '이메일';
  static const String passwordLabel = '비밀번호';
  static const String loginButtonText = '로그인';
  static const String loginTitle = '로그인';
  static const String signupPrompt = '회원가입이 필요하신가요?';
  static const String signupButtonText = '회원가입';
}
