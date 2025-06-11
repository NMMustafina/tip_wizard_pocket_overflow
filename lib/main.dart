import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'models/check_model.dart';
import 'screens/main_screen.dart';
import 'screens/onboarding_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(CheckModelAdapter());
  await Hive.openBox<CheckModel>('checks');
  await Hive.openBox('settings');

  final settingsBox = Hive.box('settings');
  final isFirstLaunch = settingsBox.get('isFirstLaunch', defaultValue: true);

  runApp(MyApp(isFirstLaunch: isFirstLaunch));
}

class MyApp extends StatelessWidget {
  final bool isFirstLaunch;
  const MyApp({super.key, required this.isFirstLaunch});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: isFirstLaunch ? const OnboardingScreen() : const MainScreen(),
    );
  }
}
