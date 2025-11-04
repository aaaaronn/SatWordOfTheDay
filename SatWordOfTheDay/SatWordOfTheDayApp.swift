//
//  SatWordOfTheDayApp.swift
//  SatWordOfTheDay
//
//  Created by akramp on 10/3/25.
//

import SwiftUI

@main
struct SatWordOfTheDayApp: App {
    @State private var hasLoadedWords = false;
    @State var words: [SATWord] = []
    
    var body: some Scene {
        WindowGroup {
            if !hasLoadedWords {
                LoadingView()
                    .onAppear(perform: loadWords)
            } else {
                ContentView(words: $words)
            }
        }
    }
    
    // shifting to left one -1
    func loadWords() {
        self.words = GetSATWords()
        guard !words.isEmpty else { return }
        
        hasLoadedWords = true;
    }
}
