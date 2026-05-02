import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/word.dart';
import '../services/daily_word_service.dart';
import '../services/settings_controller.dart';
import 'settings_screen.dart';

class HomeScreen extends StatefulWidget {
  final SettingsController controller;
  const HomeScreen({super.key, required this.controller});

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

  TextStyle _heading(Palette p, FontOption font, {required double size}) {
    return font == FontOption.classic
        ? GoogleFonts.playfairDisplay(
            fontSize: size,
            fontWeight: FontWeight.w700,
            color: p.textPrimary,
          )
        : GoogleFonts.atkinsonHyperlegible(
            fontSize: size,
            fontWeight: FontWeight.w700,
            color: p.textPrimary,
          );
  }

  TextStyle _italicAccent(Palette p, FontOption font, {required double size}) {
    return font == FontOption.classic
        ? GoogleFonts.playfairDisplay(
            fontSize: size,
            fontStyle: FontStyle.italic,
            color: p.accent,
          )
        : GoogleFonts.atkinsonHyperlegible(
            fontSize: size,
            fontStyle: FontStyle.italic,
            color: p.accent,
          );
  }

  TextStyle _body(Palette p, FontOption font, {required double size}) {
    return font == FontOption.classic
        ? GoogleFonts.inter(
            fontSize: size,
            height: 1.5,
            color: p.textBody,
          )
        : GoogleFonts.atkinsonHyperlegible(
            fontSize: size,
            height: 1.55,
            color: p.textBody,
          );
  }

  TextStyle _label(Palette p, FontOption font) {
    final family = font == FontOption.classic
        ? GoogleFonts.inter(
            fontSize: 11,
            letterSpacing: 1.8,
            color: p.accent,
            fontWeight: FontWeight.w600,
          )
        : GoogleFonts.atkinsonHyperlegible(
            fontSize: 11,
            letterSpacing: 1.5,
            color: p.accent,
            fontWeight: FontWeight.w700,
          );
    return family;
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.controller,
      builder: (context, _) {
        final s = widget.controller.value;
        final p = s.theme.palette;
        final font = s.font;
        return Scaffold(
          backgroundColor: p.background,
          body: SafeArea(
            child: Stack(
              children: [
                FutureBuilder<Word>(
                  future: _todayFuture,
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Center(
                        child: CircularProgressIndicator(color: p.accent),
                      );
                    }
                    final w = snapshot.data!;
                    return SingleChildScrollView(
                      padding:
                          const EdgeInsets.fromLTRB(28, 64, 28, 48),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _todayLabel().toUpperCase(),
                            style: _label(p, font),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Word of the day',
                            style: font == FontOption.classic
                                ? GoogleFonts.inter(
                                    fontSize: 14,
                                    color: p.textMuted,
                                  )
                                : GoogleFonts.atkinsonHyperlegible(
                                    fontSize: 14,
                                    color: p.textMuted,
                                  ),
                          ),
                          const SizedBox(height: 28),
                          Text(w.word, style: _heading(p, font, size: 52)),
                          const SizedBox(height: 6),
                          Text(
                            w.partOfSpeech,
                            style: _italicAccent(p, font, size: 18),
                          ),
                          const SizedBox(height: 32),
                          _section('Definition', w.definition, p, font),
                          _section('Etymology', w.etymology, p, font),
                          _sectionItalic(
                              'Example', '“${w.example}”', p, font),
                        ],
                      ),
                    );
                  },
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: Material(
                    color: Colors.transparent,
                    child: IconButton(
                      icon: Icon(Icons.tune, color: p.textPrimary),
                      tooltip: 'Settings',
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (_) => SettingsScreen(
                            controller: widget.controller,
                          ),
                        ));
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _section(String label, String body, Palette p, FontOption font) =>
      Padding(
        padding: const EdgeInsets.only(bottom: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label.toUpperCase(), style: _label(p, font)),
            const SizedBox(height: 8),
            Text(body, style: _body(p, font, size: 16)),
          ],
        ),
      );

  Widget _sectionItalic(
          String label, String body, Palette p, FontOption font) =>
      Padding(
        padding: const EdgeInsets.only(bottom: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label.toUpperCase(), style: _label(p, font)),
            const SizedBox(height: 8),
            Text(
              body,
              style: font == FontOption.classic
                  ? GoogleFonts.playfairDisplay(
                      fontSize: 16,
                      fontStyle: FontStyle.italic,
                      height: 1.5,
                      color: p.textBody,
                    )
                  : GoogleFonts.atkinsonHyperlegible(
                      fontSize: 16,
                      fontStyle: FontStyle.italic,
                      height: 1.55,
                      color: p.textBody,
                    ),
            ),
          ],
        ),
      );
}
