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

func GetSATWords() -> [SATWord]
{
    if let url = Bundle.main.url(forResource: "sat_words", withExtension: "json") {
        if let data = try? Data(contentsOf: url) {
            if let loadedWords = try? JSONDecoder().decode([SATWord].self, from: data) {
                return loadedWords
            }
        }
    }
    return []
}
