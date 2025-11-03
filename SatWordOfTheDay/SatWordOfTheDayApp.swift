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
        let startingDay = (Calendar.current.ordinality(of: .day, in: .year, for: Date()) ?? 1) % words.count
        debugPrint("target center word: \(words[startingDay].word)")
        // left side has bias
        let rightCount : Int = words.count / 2
        let leftCount : Int = words.count - rightCount
        
        // get indexes of should be start and should be end
        var startIndex : Int = startingDay - leftCount
        var endIndex : Int = startingDay + rightCount
        var firstHalf : [SATWord]
        var secondHalf : [SATWord]
        // wrap indexes to center current days word
        if startIndex < 0 {
            startIndex += words.count
            firstHalf = Array(words[startIndex...] + words[0..<startingDay])
        } else {
            firstHalf = Array(words[startIndex..<startingDay])
        }
        if endIndex > words.count {
            endIndex -= words.count
            secondHalf = Array(words[startingDay...] + words[0..<endIndex])
        } else {
            secondHalf = Array(words[startingDay..<endIndex])
        }
        words = Array(firstHalf + secondHalf)
        
        debugPrint("words: \(words.count)   center word: \(words[words.count/2].word)")
        
            
        hasLoadedWords = true;
    }
}
