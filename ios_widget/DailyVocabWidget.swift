// Place inside the new Widget Extension target you create in Xcode (File ▸ New ▸ Target ▸ Widget Extension, name "DailyVocabWidget").
// Replace the auto-generated widget Swift file's contents with this one.
// Both the main app target and the widget target must be members of the same App Group:
//   group.com.dailyvocab
// (Signing & Capabilities ▸ + Capability ▸ App Groups ▸ add group.com.dailyvocab to BOTH targets.)

import WidgetKit
import SwiftUI

private let appGroupId = "group.com.dailyvocab"

struct VocabEntry: TimelineEntry {
    let date: Date
    let word: String
    let definition: String
}

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> VocabEntry {
        VocabEntry(
            date: Date(),
            word: "Petrichor",
            definition: "The pleasant earthy smell after rain."
        )
    }

    func getSnapshot(in context: Context, completion: @escaping (VocabEntry) -> Void) {
        completion(readEntry())
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<VocabEntry>) -> Void) {
        let entry = readEntry()
        // Refresh shortly after the next local midnight.
        let cal = Calendar.current
        let nextMidnight = cal.nextDate(
            after: Date(),
            matching: DateComponents(hour: 0, minute: 1),
            matchingPolicy: .nextTime
        ) ?? Date().addingTimeInterval(60 * 60 * 6)
        completion(Timeline(entries: [entry], policy: .after(nextMidnight)))
    }

    private func readEntry() -> VocabEntry {
        let defaults = UserDefaults(suiteName: appGroupId)
        let word = defaults?.string(forKey: "vocab_word") ?? "Petrichor"
        let def  = defaults?.string(forKey: "vocab_definition")
            ?? "The pleasant earthy smell after rain."
        return VocabEntry(date: Date(), word: word, definition: def)
    }
}

struct DailyVocabWidgetEntryView: View {
    var entry: Provider.Entry

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("WORD OF THE DAY")
                .font(.system(size: 10, weight: .semibold))
                .tracking(1.5)
                .foregroundColor(Color(red: 0.55, green: 0.44, blue: 0.28))
            Text(entry.word)
                .font(.system(size: 22, weight: .bold, design: .serif))
                .foregroundColor(Color(red: 0.10, green: 0.10, blue: 0.10))
                .lineLimit(1)
                .minimumScaleFactor(0.7)
            Text(entry.definition)
                .font(.system(size: 13))
                .foregroundColor(Color(red: 0.17, green: 0.17, blue: 0.17))
                .lineLimit(3)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .padding(14)
        .containerBackground(Color(red: 0.98, green: 0.97, blue: 0.95), for: .widget)
    }
}

@main
struct DailyVocabWidget: Widget {
    let kind: String = "DailyVocabWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            DailyVocabWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Daily Vocab")
        .description("A new word every day.")
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}
