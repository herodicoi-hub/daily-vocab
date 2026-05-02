import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/word.dart';
import '../services/daily_word_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _service = DailyWordService();
  late Future<Word> _todayFuture;

  @override
  void initState() {
    super.initState();
    _todayFuture = _service.today();
    _service.updateWidget();
  }

  String _todayLabel() {
    final d = DateTime.now();
    const months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    return '${months[d.month - 1]} ${d.day}, ${d.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAF7F2),
      body: SafeArea(
        child: FutureBuilder<Word>(
          future: _todayFuture,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }
            final w = snapshot.data!;
            return SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(28, 32, 28, 48),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _todayLabel().toUpperCase(),
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      letterSpacing: 2,
                      color: Colors.black54,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Word of the day',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      color: Colors.black45,
                    ),
                  ),
                  const SizedBox(height: 28),
                  Text(
                    w.word,
                    style: GoogleFonts.playfairDisplay(
                      fontSize: 52,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF1A1A1A),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    w.partOfSpeech,
                    style: GoogleFonts.playfairDisplay(
                      fontSize: 18,
                      fontStyle: FontStyle.italic,
                      color: const Color(0xFF8B6F47),
                    ),
                  ),
                  const SizedBox(height: 32),
                  _section('Definition', w.definition),
                  _section('Etymology', w.etymology),
                  _sectionItalic('Example', '“${w.example}”'),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _section(String label, String body) => Padding(
        padding: const EdgeInsets.only(bottom: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label.toUpperCase(),
              style: GoogleFonts.inter(
                fontSize: 11,
                letterSpacing: 1.8,
                color: const Color(0xFF8B6F47),
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              body,
              style: GoogleFonts.inter(
                fontSize: 16,
                height: 1.5,
                color: const Color(0xFF2C2C2C),
              ),
            ),
          ],
        ),
      );

  Widget _sectionItalic(String label, String body) => Padding(
        padding: const EdgeInsets.only(bottom: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label.toUpperCase(),
              style: GoogleFonts.inter(
                fontSize: 11,
                letterSpacing: 1.8,
                color: const Color(0xFF8B6F47),
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              body,
              style: GoogleFonts.playfairDisplay(
                fontSize: 16,
                fontStyle: FontStyle.italic,
                height: 1.5,
                color: const Color(0xFF2C2C2C),
              ),
            ),
          ],
        ),
      );
}
