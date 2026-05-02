import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const DailyVocabApp());
}

class DailyVocabApp extends StatelessWidget {
  const DailyVocabApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Daily Vocab',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF8B6F47)),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}
