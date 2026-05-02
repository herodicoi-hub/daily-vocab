#!/usr/bin/env bash
# Run AFTER `flutter create .` has generated the android/ scaffolding.
# Copies the widget files into the right Android paths and patches the manifest.
set -euo pipefail

ANDROID_DIR="android/app/src/main"
PKG_DIR="$ANDROID_DIR/kotlin/com/example/daily_vocab"
RES_DIR="$ANDROID_DIR/res"

mkdir -p "$PKG_DIR" "$RES_DIR/xml" "$RES_DIR/layout" "$RES_DIR/drawable"

cp android_widget/DailyVocabWidgetProvider.kt "$PKG_DIR/DailyVocabWidgetProvider.kt"
cp android_widget/daily_vocab_widget.xml      "$RES_DIR/layout/daily_vocab_widget.xml"
cp android_widget/daily_vocab_widget_info.xml "$RES_DIR/xml/daily_vocab_widget_info.xml"
cp android_widget/widget_background.xml       "$RES_DIR/drawable/widget_background.xml"

python3 - <<'PY'
from pathlib import Path
manifest = Path("android/app/src/main/AndroidManifest.xml")
content = manifest.read_text()

receiver = """
        <receiver
            android:name=".DailyVocabWidgetProvider"
            android:exported="true">
            <intent-filter>
                <action android:name="android.appwidget.action.APPWIDGET_UPDATE" />
            </intent-filter>
            <meta-data
                android:name="android.appwidget.provider"
                android:resource="@xml/daily_vocab_widget_info" />
        </receiver>
"""

if "DailyVocabWidgetProvider" not in content:
    content = content.replace("</application>", receiver + "    </application>")
    manifest.write_text(content)
    print("Patched AndroidManifest.xml")
else:
    print("Manifest already patched, skipping")
PY

echo "Android widget files in place."
