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
        VStack(alignment: .leading) {
            Text(entry.word.word)
                .font(.system(size: 35))
                .bold()
                .padding(.top, 12)
                .padding(.bottom, 2)
                .lineLimit(1)
                .minimumScaleFactor(0.1)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            Text(entry.word.definition)
                .font(.body)
                .minimumScaleFactor(0.2)
                //.multilineTextAlignment(.center)
            
            Spacer()
        }
        .padding(.horizontal, 5)
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
    WordEntry(date: .now, word: SATWord(word: "Hello", definition: "a word that words"))

    WordEntry(date: .now + 1, word: SATWord(word: "Complacent", definition: "a word that words particularly well"))
}


#Preview(as: .systemMedium) {
    WordWidgetExtension()
} timeline: {
    WordEntry(date: .now, word: SATWord(word: "Hello", definition: "a common greeting"))

    WordEntry(date: .now + 1, word: SATWord(word: "Goodbye", definition: "a common parting"))
}
