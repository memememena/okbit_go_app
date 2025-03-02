import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:okbit_go_app/providers/auth_provider.dart';
import 'package:okbit_go_app/providers/navigation_provider.dart';
import 'package:okbit_go_app/utils/constants.dart'; // 상수 파일을 import

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    checkLoginStatus();
  }

  // 로그인 상태 확인
  void checkLoginStatus() async {
    await Future.delayed(const Duration(seconds: 3)); // 3초 동안 대기 (스플래시 화면 유지)

    if (!mounted) return;

    final authProvider = context.read<AuthProvider>();
    if (authProvider.user != null) {
      context.read<NavigationProvider>().goToTab(context, NavigationTab.home);
    } else {
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // 배경 색상
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 상수로 정의한 로고 이미지 경로 사용
            Image.asset(Assets.logo, width: 150, height: 150), // 로고 이미지 크기 조정
            const SizedBox(height: 20),
            const Text(
              '옥빛GO!',
              style: TextStyle(
                color: Colors.white,
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
