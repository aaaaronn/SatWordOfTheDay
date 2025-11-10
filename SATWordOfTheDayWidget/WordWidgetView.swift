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
                .italic()
                .fontWeight(.heavy)
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
            HStack {
                Spacer()
                
                Image(ImageResource.miniIcon)
                    .resizable()
                    .frame(width:32, height: 32)
                    .padding(.trailing, -5)
                    
            }
            .padding(.bottom, -5)
        }
        .padding(.horizontal, 5)
        .foregroundColor(.accent)
        
        .containerBackground(for: .widget)
        {
            LinearGradient(colors: [.accent4, .accent3], startPoint: .topLeading, endPoint: .bottom)
        }
    }
}


#Preview(as: .systemSmall) {
    WordWidgetExtension()
} timeline: {
    WordEntry(date: .now, word: SATWord(word: "Hello", definition: "a word that words", isKnown: false))

    WordEntry(date: .now + 1, word: SATWord(word: "Complacent", definition: "a word that words particularly well", isKnown: false))
}


#Preview(as: .systemMedium) {
    WordWidgetExtension()
} timeline: {
    WordEntry(date: .now, word: SATWord(word: "Hello", definition: "a common greeting", isKnown: false))

    WordEntry(date: .now + 1, word: SATWord(word: "Goodbye", definition: "a common parting", isKnown: false))
}
