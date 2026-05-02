import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:home_widget/home_widget.dart';
import '../models/word.dart';

class DailyWordService {
  static const _appGroupId = 'group.com.dailyvocab';
  static const _androidWidgetName = 'DailyVocabWidgetProvider';
  static const _iOSWidgetName = 'DailyVocabWidget';

  List<Word>? _cache;

  Future<List<Word>> _loadAll() async {
    if (_cache != null) return _cache!;
    final raw = await rootBundle.loadString('assets/words.json');
    final list = (jsonDecode(raw) as List).cast<Map<String, dynamic>>();
    _cache = list.map(Word.fromJson).toList(growable: false);
    return _cache!;
  }

  Future<Word> wordForDate(DateTime date) async {
    final words = await _loadAll();
    final dayIndex = _daysSinceEpoch(date) % words.length;
    return words[dayIndex];
  }

  Future<Word> today() => wordForDate(DateTime.now());

  Future<void> updateWidget() async {
    final w = await today();
    await HomeWidget.setAppGroupId(_appGroupId);
    await HomeWidget.saveWidgetData<String>('vocab_word', w.word);
    await HomeWidget.saveWidgetData<String>('vocab_definition', w.definition);
    await HomeWidget.updateWidget(
      androidName: _androidWidgetName,
      iOSName: _iOSWidgetName,
    );
  }

  int _daysSinceEpoch(DateTime d) {
    final utcMidnight = DateTime.utc(d.year, d.month, d.day);
    return utcMidnight.millisecondsSinceEpoch ~/ Duration.millisecondsPerDay;
  }
}
