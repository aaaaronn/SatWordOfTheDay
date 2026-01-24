//
//  KnownView.swift
//  SatWordOfTheDay
//
//  Created by akramp on 11/12/25.
//

import SwiftUI

struct KnownView: View {
    
    let knownWords: [SATWord]
    
    var body: some View {
        ZStack {
            LinearGradient(
                colors: [.accent4, .accent3],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            let columns = [
                GridItem(.flexible(), spacing: 16),
                GridItem(.flexible(), spacing: 16)
            ]
            
            Text("\(knownWords.count)")
            
            ScrollView {
                LazyVGrid(columns: columns, spacing: 16) {
                    ForEach(knownWords, id: \.word) { word in
                        WordCardView(word: word.word, definition: word.definition)
                    }
                }
                .padding()
            }
        }
    }
}

#Preview {
    KnownView(knownWords: GetKnownSATWords())
}
