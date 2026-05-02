// Place at: android/app/src/main/kotlin/com/example/daily_vocab/DailyVocabWidgetProvider.kt
// (Match the package to your app's applicationId.)

package com.example.daily_vocab

import android.appwidget.AppWidgetManager
import android.content.Context
import android.widget.RemoteViews
import es.antonborri.home_widget.HomeWidgetPlugin
import es.antonborri.home_widget.HomeWidgetProvider

class DailyVocabWidgetProvider : HomeWidgetProvider() {
    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray,
        widgetData: android.content.SharedPreferences
    ) {
        appWidgetIds.forEach { id ->
            val views = RemoteViews(context.packageName, R.layout.daily_vocab_widget).apply {
                val word = widgetData.getString("vocab_word", "Petrichor") ?: "Petrichor"
                val def = widgetData.getString(
                    "vocab_definition",
                    "The pleasant earthy smell after rain."
                ) ?: ""
                setTextViewText(R.id.widget_word, word)
                setTextViewText(R.id.widget_definition, def)
            }
            appWidgetManager.updateAppWidget(id, views)
        }
    }
}
