import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum AppThemeOption { light, dark, sepia }

enum TextSizeOption { small, normal, large, huge }

enum FontOption { classic, easyRead }

extension TextSizeOptionX on TextSizeOption {
  double get scale => switch (this) {
        TextSizeOption.small => 0.85,
        TextSizeOption.normal => 1.0,
        TextSizeOption.large => 1.2,
        TextSizeOption.huge => 1.5,
      };

  String get label => switch (this) {
        TextSizeOption.small => 'Small',
        TextSizeOption.normal => 'Default',
        TextSizeOption.large => 'Large',
        TextSizeOption.huge => 'Huge',
      };
}

extension AppThemeOptionX on AppThemeOption {
  String get label => switch (this) {
        AppThemeOption.light => 'Light',
        AppThemeOption.dark => 'Dark',
        AppThemeOption.sepia => 'Sepia',
      };

  Palette get palette => switch (this) {
        AppThemeOption.light => Palette.light,
        AppThemeOption.dark => Palette.dark,
        AppThemeOption.sepia => Palette.sepia,
      };
}

extension FontOptionX on FontOption {
  String get label => switch (this) {
        FontOption.classic => 'Classic',
        FontOption.easyRead => 'Easy Read',
      };

  String get description => switch (this) {
        FontOption.classic => 'Elegant serif for headings',
        FontOption.easyRead => 'High-readability sans-serif',
      };
}

class Palette {
  final Color background;
  final Color textPrimary;
  final Color textBody;
  final Color textMuted;
  final Color accent;
  final Color cardBorder;

  const Palette({
    required this.background,
    required this.textPrimary,
    required this.textBody,
    required this.textMuted,
    required this.accent,
    required this.cardBorder,
  });

  static const light = Palette(
    background: Color(0xFFFAF7F2),
    textPrimary: Color(0xFF1A1A1A),
    textBody: Color(0xFF2C2C2C),
    textMuted: Color(0xFF6E6356),
    accent: Color(0xFF8B6F47),
    cardBorder: Color(0xFFE8DCC4),
  );

  static const dark = Palette(
    background: Color(0xFF14110D),
    textPrimary: Color(0xFFFAF7F2),
    textBody: Color(0xFFE6E0D6),
    textMuted: Color(0xFFB0A693),
    accent: Color(0xFFD4B68C),
    cardBorder: Color(0xFF3A332A),
  );

  static const sepia = Palette(
    background: Color(0xFFF4ECD8),
    textPrimary: Color(0xFF3E2C1C),
    textBody: Color(0xFF5C4A3A),
    textMuted: Color(0xFF8B6F47),
    accent: Color(0xFFA0744F),
    cardBorder: Color(0xFFD9C9A8),
  );
}

@immutable
class AppSettings {
  final AppThemeOption theme;
  final TextSizeOption textSize;
  final FontOption font;

  const AppSettings({
    this.theme = AppThemeOption.light,
    this.textSize = TextSizeOption.normal,
    this.font = FontOption.classic,
  });

  AppSettings copyWith({
    AppThemeOption? theme,
    TextSizeOption? textSize,
    FontOption? font,
  }) =>
      AppSettings(
        theme: theme ?? this.theme,
        textSize: textSize ?? this.textSize,
        font: font ?? this.font,
      );
}

class SettingsController extends ChangeNotifier {
  static const _kTheme = 'settings.theme';
  static const _kSize = 'settings.textSize';
  static const _kFont = 'settings.font';

  AppSettings _value = const AppSettings();
  AppSettings get value => _value;

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    _value = AppSettings(
      theme: AppThemeOption.values[
          prefs.getInt(_kTheme) ?? AppThemeOption.light.index],
      textSize: TextSizeOption.values[
          prefs.getInt(_kSize) ?? TextSizeOption.normal.index],
      font:
          FontOption.values[prefs.getInt(_kFont) ?? FontOption.classic.index],
    );
    notifyListeners();
  }

  Future<void> setTheme(AppThemeOption v) async {
    _value = _value.copyWith(theme: v);
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_kTheme, v.index);
  }

  Future<void> setTextSize(TextSizeOption v) async {
    _value = _value.copyWith(textSize: v);
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_kSize, v.index);
  }

  Future<void> setFont(FontOption v) async {
    _value = _value.copyWith(font: v);
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_kFont, v.index);
  }
}
