//
//  WordProvider.swift
//  SatWordOfTheDay
//
//  Created by akramp on 10/14/25.
//

import WidgetKit

struct WordEntry: TimelineEntry {
    let date: Date
    let word: SATWord
}


struct WordProvider: TimelineProvider {
    
    private var words: [SATWord] = GetSATWords()
    
    private let placeholderEntry = WordEntry(
        date: Date(),
        word: SATWord(word: "Placeholder", definition: "A temporary replacement")
    )
    
    func placeholder(in context: Context) -> WordEntry {
        return placeholderEntry
    }
    
    func getSnapshot(in context: Context, completion: @escaping (WordEntry) -> Void) {
        completion(placeholderEntry)
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<WordEntry>) -> Void) {
        var entries : [WordEntry] = []
        
        let dayOfYear = Calendar.current.ordinality(of: .day, in: .year, for: Date()) ?? 1
        let midnight = Calendar.current.nextDate(after: Date(), matching: DateComponents(hour: 0, minute: 0, second: 0), matchingPolicy: .nextTime)!
        
        let index = dayOfYear % words.count
        let entry = WordEntry(date: Date(), word: words[index])
        entries.append(entry)
        
        let timeline = Timeline(entries: entries, policy: .after(midnight))
        
        completion(timeline)
    }
}
