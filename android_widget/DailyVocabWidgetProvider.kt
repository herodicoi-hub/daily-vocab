// Place at: android/app/src/main/kotlin/com/example/daily_vocab/DailyVocabWidgetProvider.kt
// (Match the package to your app's applicationId.)

package com.example.daily_vocab

import android.app.PendingIntent
import android.appwidget.AppWidgetManager
import android.content.Context
import android.content.Intent
import android.widget.RemoteViews
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
}
