# Daily Vocab

A minimal cross-platform vocabulary app: one new word every day, with part of speech, etymology, definition, and an example sentence. A home-screen widget shows just the word and definition.

- **Stack:** Flutter (Dart) + native widgets (Kotlin for Android, SwiftUI/WidgetKit for iOS)
- **Word source:** Bundled JSON in `assets/words.json` (~80 curated entries — extend freely)
- **Daily pick:** Deterministic by UTC date, so the same day = same word on every device

## Project layout

```
daily_vocab/
├── pubspec.yaml
├── lib/
│   ├── main.dart
│   ├── models/word.dart
│   ├── services/daily_word_service.dart
│   └── screens/home_screen.dart
├── assets/
│   └── words.json
├── android_widget/      ← drop into android/app/src/main/... after flutter create
│   ├── DailyVocabWidgetProvider.kt
│   ├── daily_vocab_widget.xml
│   ├── daily_vocab_widget_info.xml
│   ├── widget_background.xml
│   └── AndroidManifest_snippet.xml
└── ios_widget/          ← drop into the Widget Extension target you create in Xcode
    ├── DailyVocabWidget.swift
    └── Runner.entitlements_snippet.xml
```

## One-time setup

### 1. Install Flutter

Follow https://docs.flutter.dev/get-started/install/windows. After install, run:

```bash
flutter doctor
```

Resolve any red checkmarks before continuing.

### 2. Generate platform scaffolding

From `C:\Users\herod\daily_vocab`:

```bash
flutter create .
flutter pub get
```

`flutter create .` fills in `android/`, `ios/`, etc. without overwriting the existing `lib/`, `assets/`, or `pubspec.yaml`.

### 3. Wire up the Android widget

Copy the files from `android_widget/` into the matching paths under `android/app/src/main/`:

| From | To |
|---|---|
| `DailyVocabWidgetProvider.kt` | `kotlin/com/example/daily_vocab/DailyVocabWidgetProvider.kt` |
| `daily_vocab_widget.xml` | `res/layout/daily_vocab_widget.xml` |
| `daily_vocab_widget_info.xml` | `res/xml/daily_vocab_widget_info.xml` |
| `widget_background.xml` | `res/drawable/widget_background.xml` |

(If `res/xml/` doesn't exist yet, create it.)

Then open `android/app/src/main/AndroidManifest.xml` and paste the `<receiver>` block from `AndroidManifest_snippet.xml` inside `<application>...</application>`.

If you change the `applicationId` in `android/app/build.gradle` away from `com.example.daily_vocab`, update the `package` line at the top of `DailyVocabWidgetProvider.kt` and the folder it lives in to match.

### 4. Wire up the iOS widget (requires a Mac with Xcode)

1. Open `ios/Runner.xcworkspace` in Xcode.
2. **File ▸ New ▸ Target… ▸ Widget Extension.** Name it `DailyVocabWidget`. Uncheck "Include Configuration Intent."
3. Replace the contents of the auto-generated `DailyVocabWidget.swift` with `ios_widget/DailyVocabWidget.swift`.
4. Select the **Runner** target ▸ Signing & Capabilities ▸ **+ Capability ▸ App Groups**. Add `group.com.dailyvocab`.
5. Repeat step 4 for the **DailyVocabWidget** target. Both targets must share the same App Group.
6. Set the iOS Deployment Target to **17.0** or later (the widget uses the modern `containerBackground` API).

### 5. Run

```bash
flutter run
```

Plug in an Android phone (with USB debugging) or start an emulator. On first launch the app loads today's word and pushes it to the widget. Long-press your home screen ▸ Widgets ▸ **Daily Vocab** to add it.

For iOS: build to a real device or simulator from Xcode (or `flutter run`) and add the widget the usual way.

## Adding more words

Open `assets/words.json` and append entries with the same shape:

```json
{
  "word": "...",
  "partOfSpeech": "...",
  "etymology": "...",
  "definition": "...",
  "example": "..."
}
```

The daily index is `daysSinceEpoch % wordCount`, so adding entries at the end won't shuffle past days — but keep in mind every device will sync to the new pool the moment you ship an update.

## How "daily" works

`DailyWordService.wordForDate` computes `daysSinceEpoch(date) % words.length`, where `daysSinceEpoch` is the UTC midnight of the date in days since `1970-01-01`. Same date → same index → same word, on every device, with no backend required.

The widget is updated by the Flutter app whenever it opens (`updateWidget()` in `daily_word_service.dart`). The Android widget also self-refreshes hourly via `updatePeriodMillis`; the iOS widget asks WidgetKit to refresh shortly after the next local midnight.

## Known limitations

- The widget only refreshes when the app runs OR on the platform's own schedule. If a user never opens the app, Android refreshes hourly from cached data, and iOS refreshes around midnight per its timeline policy. That's fine for a daily-word use case.
- If you want server-pushed words later (e.g. Claude API generating a fresh entry daily), swap `DailyWordService._loadAll()` for an HTTP call and cache the result.
