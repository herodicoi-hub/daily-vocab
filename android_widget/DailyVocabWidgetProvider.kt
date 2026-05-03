// Place at: android/app/src/main/kotlin/com/example/daily_vocab/DailyVocabWidgetProvider.kt

package com.example.daily_vocab

import android.app.PendingIntent
import android.appwidget.AppWidgetManager
import android.content.Context
import android.content.Intent
import android.widget.RemoteViews
import es.antonborri.home_widget.HomeWidgetProvider
import org.json.JSONArray

class DailyVocabWidgetProvider : HomeWidgetProvider() {

    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray,
        widgetData: android.content.SharedPreferences
    ) {
        val (word, definition) = todayWord(context)

        appWidgetIds.forEach { id ->
            val views = RemoteViews(context.packageName, R.layout.daily_vocab_widget).apply {
                setTextViewText(R.id.widget_word, word)
                setTextViewText(R.id.widget_definition, definition)

                val launchIntent = Intent(context, MainActivity::class.java).apply {
                    flags = Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_CLEAR_TOP
                }
                val pendingIntent = PendingIntent.getActivity(
                    context,
                    0,
                    launchIntent,
                    PendingIntent.FLAG_IMMUTABLE or PendingIntent.FLAG_UPDATE_CURRENT
                )
                setOnClickPendingIntent(R.id.widget_root, pendingIntent)
            }
            appWidgetManager.updateAppWidget(id, views)
        }
    }

    /**
     * Compute today's word from the bundled JSON, independent of whether
     * the Flutter app has been opened. Matches DailyWordService.wordForDate
     * in lib/services/daily_word_service.dart: index = daysSinceEpochUtc % count.
     */
    private fun todayWord(context: Context): Pair<String, String> {
        return try {
            val raw = context.resources.openRawResource(R.raw.words)
                .bufferedReader().use { it.readText() }
            val words = JSONArray(raw)
            val msPerDay = 1000L * 60L * 60L * 24L
            val daysSinceEpoch = System.currentTimeMillis() / msPerDay
            val index = (daysSinceEpoch % words.length()).toInt()
            val w = words.getJSONObject(index)
            Pair(w.getString("word"), w.getString("definition"))
        } catch (e: Exception) {
            Pair("Petrichor", "The pleasant earthy smell after rain.")
        }
    }
}
