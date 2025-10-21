//
//  WordWidgetView.swift
//  SatWordOfTheDay
//
//  Created by akramp on 10/15/25.
//

import WidgetKit
import SwiftUI

struct WordWidgetView: View {
    var entry: WordProvider.Entry
    
    var body: some View {
        VStack() {
            
            Text(entry.word.word)
                .font(.title)
                .bold()
                .padding(.bottom, 2)
                .padding(.top, 16)
                .lineLimit(1)
                .minimumScaleFactor(0.1)
            
            Text(entry.word.definition)
                .font(.body)
                .multilineTextAlignment(.center)
            
            Spacer()
        }
        .foregroundColor(.accent)
        
        .containerBackground(for: .widget)
        {
            Color.accent3
        }
    }
}

#Preview(as: .systemSmall) {
    WordWidgetExtension()
} timeline: {
    WordEntry(date: .now, word: SATWord(word: "Hello", definition: "a common greeting"))
    WordEntry(date: .now + 1, word: SATWord(word: "Complacent", definition: "a common parting"))
}

#Preview(as: .systemMedium) {
    WordWidgetExtension()
} timeline: {
    WordEntry(date: .now, word: SATWord(word: "Hello", definition: "a common greeting"))
    WordEntry(date: .now + 1, word: SATWord(word: "Goodbye", definition: "a common parting"))
}
