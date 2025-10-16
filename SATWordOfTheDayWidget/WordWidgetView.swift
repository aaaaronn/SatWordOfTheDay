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
            Text("Word of the day")
                .lineLimit(1)
                .minimumScaleFactor(0.1)
            
            Spacer()
            
            Text(entry.word.word)
                .font(.title)
                .bold()
                .padding(.bottom, 2)
            
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
