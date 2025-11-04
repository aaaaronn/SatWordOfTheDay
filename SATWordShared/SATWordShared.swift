//
//  SATWordShared.swift
//  SatWordOfTheDay
//
//  Created by akramp on 10/15/25.
//

import SwiftUI

struct SATWord: Decodable, Equatable {
    let word: String
    let definition: String
}

// return words json with current word at center (words.count/2)
func GetSATWords() -> [SATWord]
{
    if let url = Bundle.main.url(forResource: "sat_words", withExtension: "json") {
        if let data = try? Data(contentsOf: url) {
            if let words = try? JSONDecoder().decode([SATWord].self, from: data) {
                guard !words.isEmpty else { return [] }
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
                return Array(firstHalf + secondHalf)
            }
        }
    }
    return []
}
