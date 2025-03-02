import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:okbit_go_app/providers/navigation_provider.dart';
import 'package:okbit_go_app/providers/auth_provider.dart';
import 'package:okbit_go_app/providers/meal_provider.dart';
import 'package:okbit_go_app/providers/timetable_provider.dart';
import 'package:okbit_go_app/routes.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:okbit_go_app/firebase_options.dart';
import 'package:okbit_go_app/services/meal_service.dart';
import 'package:okbit_go_app/services/meal_storage_service.dart';
import 'package:okbit_go_app/services/timetable_service.dart';
import 'package:okbit_go_app/services/timetable_storage_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final mealStorageService = await MealStorageService.create();
  final timeTableStorageService = await TimeTableStorageService.create();

  runApp(MyApp(
    mealStorageService: mealStorageService,
    timeTableStorageService: timeTableStorageService,
  ));
}

class MyApp extends StatelessWidget {
  final MealStorageService mealStorageService;
  final TimeTableStorageService timeTableStorageService;

  const MyApp({
    super.key,
    required this.mealStorageService,
    required this.timeTableStorageService,
  });

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => NavigationProvider()),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(
          create: (_) => MealProvider(
            MealService(),
            mealStorageService,
          ),
        ),
        ChangeNotifierProvider(
          create: (_) => TimeTableProvider(
            TimeTableService(),
            timeTableStorageService,
          ),
        ),
      ],
      child: MaterialApp(
        title: 'OKBIT GO',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        initialRoute: AppRoutes.splash,
        onGenerateRoute: AppRoutes.generateRoute,
        routes: AppRoutes.getRoutes(),
      ),
    );
  }
}
