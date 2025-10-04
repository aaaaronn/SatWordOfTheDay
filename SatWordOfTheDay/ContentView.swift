//
//  ContentView.swift
//  SatWordOfTheDay
//
//  Created by akramp on 10/3/25.
//

import SwiftUI

struct SATWord: Decodable {
    let word: String
    let definition: String
}

struct ContentView: View {
    @State private var currentDate = Date()
    @State private var currentWordIndex = 0
    
    @State private var words: [SATWord] = []
    
    var body: some View {
        HStack() {
            Button(action: {
                currentDate = Calendar.current.date(byAdding: .day, value: -1, to: currentDate) ?? currentDate
                if (currentWordIndex > 0) { currentWordIndex -= 1 }
            }) {
                Image(systemName: "chevron.left")
                    .font(.title2)
            }
            
            Spacer()
            
            Text(currentDate, style: .date)
                .font(.headline)
                .bold()
            
            Spacer()
            
            Button(action: {
                currentDate = Calendar.current.date(byAdding: .day, value: 1, to: currentDate) ?? currentDate
                if (currentWordIndex < words.count - 1) { currentWordIndex += 1 }
            }) {
                Image(systemName: "chevron.right")
                    .font(.title2)
            }
        }
        .padding()
        
        Spacer()
        
        VStack(spacing:20) {
            if !words.isEmpty {
                Text(words[currentWordIndex].word)
                    .font(.largeTitle)
                    .bold()
                    .foregroundColor(.accentColor)
                Text(words[currentWordIndex].definition)
                    .font(.body)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            } else {
                  Text("Loading...")
            }
        }
        .padding()
        .background(.ultraThinMaterial)
        .cornerRadius(16)
        .shadow(radius: 5)
        .onAppear {
            loadWords()
        }
        
        Spacer()
    }
    
    func loadWords() {
        if let url = Bundle.main.url(forResource: "sat_words", withExtension: "json") {
            if let data = try? Data(contentsOf: url) {
                if let loadedWords = try? JSONDecoder().decode([SATWord].self, from: data) {
                    self.words = loadedWords
                    showWordOfTheDay()
                }
            }
        }
    }
    
    func showWordOfTheDay()
    {
        let dayOfYear = Calendar.current.ordinality(of: .day, in: .year, for: Date()) ?? 1
        
        currentWordIndex = dayOfYear % words.count
        
    }
}

#Preview {
    ContentView()
}
