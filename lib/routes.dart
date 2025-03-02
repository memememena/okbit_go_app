import 'package:flutter/material.dart';
import 'package:okbit_go_app/screens/login/login_screen.dart';
import 'package:okbit_go_app/screens/login/signup_screen.dart';
import 'package:okbit_go_app/screens/splash/splash_screen.dart';
import 'package:okbit_go_app/screens/main_screen.dart';
import 'package:okbit_go_app/providers/navigation_provider.dart';
import 'package:provider/provider.dart';
import 'screens/home_screen.dart';

class AppRoutes {
  // 앱의 라우터 정의
  static const String splash = '/';
  static const String login = '/login';
  static const String home = '/home';
  static const String signup = '/signup';
  static const String main = '/main';

  // 라우터 설정
  static Map<String, WidgetBuilder> getRoutes() {
    return {
      splash: (context) => const SplashScreen(),
      login: (context) => const LoginScreen(),
      home: (context) => const HomeScreen(),
      signup: (context) => const SignupScreen(),
      main: (context) => const MainScreen(),
    };
  }

  static Route<dynamic> generateRoute(RouteSettings settings) {
    if (settings.name?.startsWith('$main/') ?? false) {
      final tabName = settings.name!.split('/').last;
      final tab = NavigationTab.values.firstWhere(
        (tab) => tab.name == tabName,
        orElse: () => NavigationTab.home,
      );

      return MaterialPageRoute(
        builder: (context) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            context.read<NavigationProvider>().setTab(tab);
          });
          return const MainScreen();
        },
      );
    }

    final routes = getRoutes();
    final WidgetBuilder? builder = routes[settings.name];

    if (builder != null) {
      return MaterialPageRoute(builder: builder);
    }

    return MaterialPageRoute(builder: (context) => const SplashScreen());
  }
}

final Map<String, WidgetBuilder> routes = {
  '/': (context) => const HomeScreen(),
  '/main': (context) => const MainScreen(),
};
