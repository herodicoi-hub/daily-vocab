import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'services/settings_controller.dart';

late final SettingsController settingsController;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  settingsController = SettingsController();
  await settingsController.load();
  runApp(DailyVocabApp(controller: settingsController));
}

class DailyVocabApp extends StatelessWidget {
  final SettingsController controller;
  const DailyVocabApp({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        final s = controller.value;
        return MaterialApp(
          title: 'Daily Vocab',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(
              seedColor: const Color(0xFF8B6F47),
              brightness: s.theme == AppThemeOption.dark
                  ? Brightness.dark
                  : Brightness.light,
            ),
            useMaterial3: true,
          ),
          builder: (context, child) {
            final mq = MediaQuery.of(context);
            return MediaQuery(
              data: mq.copyWith(
                textScaler: TextScaler.linear(s.textSize.scale),
              ),
              child: child ?? const SizedBox.shrink(),
            );
          },
          home: HomeScreen(controller: controller),
        );
      },
    );
  }
}
