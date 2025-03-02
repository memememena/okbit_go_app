import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:okbit_go_app/utils/theme.dart'; // 테마 파일을 import
import 'package:okbit_go_app/widgets/custom_button.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Firestore 사용을 위해 다시 추가

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _auth = FirebaseAuth.instance;
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _gradeController = TextEditingController();
  final _classController = TextEditingController();
  final _studentNumberController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _gradeController.dispose();
    _classController.dispose();
    _studentNumberController.dispose();
    super.dispose();
  }

  // Define constants for colors and text styles
  // 기존 상수 제거

  // 회원가입 기능
  Future<void> _signup() async {
    if (_passwordController.text.trim() !=
        _confirmPasswordController.text.trim()) {
      // 비밀번호 확인 불일치 처리
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('비밀번호 불일치'),
            content: const Text('비밀번호가 일치하지 않습니다.'),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('확인'),
              ),
            ],
          );
        },
      );
      return;
    }

    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      // Firestore에 사용자 정보 저장
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userCredential.user?.uid)
          .set({
        'name': _nameController.text.trim(),
        'email': _emailController.text.trim(),
        'grade': int.parse(_gradeController.text.trim()),
        'class': int.parse(_classController.text.trim()),
        'studentNumber': int.parse(_studentNumberController.text.trim()),
        'createdAt': Timestamp.now(),
        'isLoggedIn': false,
      });

      if (!mounted) return;
      Navigator.pushReplacementNamed(context, '/login');
    } catch (e) {
      // 오류 처리
      if (!mounted) return;
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('회원가입 실패'),
            content: const Text('이미 사용 중인 이메일이거나 오류가 발생했습니다.'),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: DarkTheme.backgroundColor, // 다크 테마 배경 색상 사용
      appBar: AppBar(
        title: const Text('회원가입', style: TextStyle(color: Colors.white)),
        backgroundColor: DarkTheme.backgroundColor, // 다크 테마 배경 색상 사용
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 이름 입력
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: '이름',
                labelStyle: TextStyle(color: Colors.white),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue),
                ),
              ),
              style: const TextStyle(color: Colors.white),
            ),
            const SizedBox(height: 16),
            // 이메일 입력
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: '이메일',
                labelStyle: TextStyle(color: Colors.white),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue),
                ),
              ),
              style: const TextStyle(color: Colors.white),
              keyboardType: TextInputType.emailAddress, // 이메일 입력을 위한 키보드
            ),
            const SizedBox(height: 16),
            // 비밀번호 입력
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(
                labelText: '비밀번호',
                labelStyle: TextStyle(color: Colors.white),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue),
                ),
              ),
              style: const TextStyle(color: Colors.white),
              obscureText: true,
            ),
            const SizedBox(height: 16),
            // 비밀번호 확인 입력
            TextField(
              controller: _confirmPasswordController,
              decoration: const InputDecoration(
                labelText: '비밀번호 확인',
                labelStyle: TextStyle(color: Colors.white),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue),
                ),
              ),
              style: const TextStyle(color: Colors.white),
              obscureText: true,
            ),
            const SizedBox(height: 16),
            // 학년 입력
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _gradeController,
                    decoration: const InputDecoration(
                      labelText: '학년',
                      labelStyle: TextStyle(color: Colors.white),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue),
                      ),
                    ),
                    style: const TextStyle(color: Colors.white),
                    keyboardType: TextInputType.number, // 학년 입력을 위한 키보드
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextField(
                    controller: _classController,
                    decoration: const InputDecoration(
                      labelText: '반',
                      labelStyle: TextStyle(color: Colors.white),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue),
                      ),
                    ),
                    style: const TextStyle(color: Colors.white),
                    keyboardType: TextInputType.number, // 반 입력을 위한 키보드
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // 번호 입력
            TextField(
              controller: _studentNumberController,
              decoration: const InputDecoration(
                labelText: '번호',
                labelStyle: TextStyle(color: Colors.white),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue),
                ),
              ),
              style: const TextStyle(color: Colors.white),
              keyboardType: TextInputType.number, // 번호 입력을 위한 키보드
            ),
            const SizedBox(height: 24),
            // 회원가입 버튼
            CustomButton(
              text: '회원가입',
              onPressed: _signup,
            ),
            const SizedBox(height: 16),
            // 로그인 링크
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  '이미 계정이 있으신가요? ',
                  style: TextStyle(color: Colors.white),
                ),
                TextButton(
                  onPressed: () {
                    // 로그인 화면으로 이동
                    Navigator.pushReplacementNamed(context, '/login');
                  },
                  child: const Text(
                    '로그인',
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
