import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:okbit_go_app/providers/auth_provider.dart';
import 'package:okbit_go_app/providers/navigation_provider.dart';
import 'package:okbit_go_app/utils/constants.dart'; // 상수 파일을 import
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:okbit_go_app/utils/theme.dart'; // 테마 파일을 import
import 'package:okbit_go_app/widgets/custom_button.dart';

//TODO : 로그인되었을 경우 홈화면 띄울때 로그인창 뜨는거 수정 / 로그아웃 기능 구현
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();

  // 미사용 변수 제거

  // 로그인 기능
  Future<void> _login() async {
    try {
      final authProvider = context.read<AuthProvider>();
      await authProvider.signIn(
        _emailController.text.trim(),
        _passwordController.text.trim(),
      );

      if (!mounted) return;

      final user = authProvider.user;
      if (user != null) {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .set({'isLoggedIn': true}, SetOptions(merge: true));

        if (!mounted) return;
        Navigator.pushNamedAndRemoveUntil(context, '/main', (route) => false);
        context.read<NavigationProvider>().setTab(NavigationTab.home);
      }
    } catch (e) {
      if (!mounted) return;

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('로그인 실패'),
            content: const Text('이메일 또는 비밀번호가 잘못되었습니다.'),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('확인'),
              ),
            ],
          );
        },
      );
    }
  }

  // 로그인 상태 확인
  Future<void> _checkLoginStatus() async {
    final authProvider = context.read<AuthProvider>();
    final user = authProvider.user;
    if (user != null) {
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      final isLoggedIn = doc.data()?['isLoggedIn'] ?? false;
      if (isLoggedIn && mounted) {
        Navigator.pushNamedAndRemoveUntil(context, '/main', (route) => false);
        context.read<NavigationProvider>().setTab(NavigationTab.home);
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // 이메일 입력 필드에 자동 포커스 설정
    FocusScope.of(context).requestFocus(_emailFocusNode);
  }

  @override
  void dispose() {
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: DarkTheme.backgroundColor, // 배경 색상을 다크 테마로 변경
      appBar: AppBar(
        title: const Text(
          Constants.loginTitle,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: DarkTheme.textColor, // 텍스트 색상을 다크 테마로 변경
          ),
        ),
        backgroundColor: DarkTheme.backgroundColor, // 앱바 배경을 다크 테마로 변경
        elevation: 0, // 그림자 제거
        iconTheme: const IconThemeData(color: DarkTheme.textColor),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 이메일 입력
            TextField(
              controller: _emailController,
              focusNode: _emailFocusNode,
              decoration: const InputDecoration(
                labelText: Constants.emailLabel,
                labelStyle: DarkTheme.textStyle, // 다크 테마 글자색 사용
                enabledBorder: DarkTheme.inputBorder,
                focusedBorder: DarkTheme.inputBorder,
              ),
              style: DarkTheme.textStyle, // 다크 테마 텍스트 색상 사용
              keyboardType: TextInputType.emailAddress,
              cursorColor: DarkTheme.cursorColor, // 커서 색상을 테마에서 가져옴
            ),
            const SizedBox(height: 16),
            // 비밀번호 입력
            TextField(
              controller: _passwordController,
              focusNode: _passwordFocusNode,
              decoration: const InputDecoration(
                labelText: Constants.passwordLabel,
                labelStyle: DarkTheme.textStyle, // 다크 테마 글자색 사용
                enabledBorder: DarkTheme.inputBorder,
                focusedBorder: DarkTheme.inputBorder,
              ),
              style: DarkTheme.textStyle, // 다크 테마 텍스트 색상 사용
              obscureText: true,
              cursorColor: DarkTheme.cursorColor, // 커서 색상을 테마에서 가져옴
            ),
            const SizedBox(height: 24),
            // 로그인 버튼
            CustomButton(text: Constants.loginButtonText, onPressed: _login),
            const SizedBox(height: 16),
            // 회원가입 링크
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  Constants.signupPrompt,
                  style: TextStyle(color: DarkTheme.textColor),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, '/signup');
                  },
                  child: const Text(
                    Constants.signupButtonText,
                    style: TextStyle(color: Colors.blue),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
