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
    @State private var isMovingRight = true
    @State private var showDef = false
    var cardTransitionEdge: Edge {
        isMovingRight ? .trailing : .leading
    }

    @State private var words: [SATWord] = []

    var body: some View {
        ZStack {
            Color.background.ignoresSafeArea()
            VStack {
                HStack() {
                    Button(action: {
                        if (currentWordIndex > 0) {
                            isMovingRight = false
                            currentWordIndex -= 1
                            currentDate = Calendar.current.date(byAdding: .day, value: -1, to: currentDate) ?? currentDate
                        }
                    }) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 50))
                    }

                    Spacer()

                    Text(currentDate, style: .date)
                        .font(.system(size: 25))
                        .bold()

                    Spacer()

                    Button(action: {
                        if (currentWordIndex < words.count - 1) {
                            isMovingRight = true
                            currentWordIndex += 1
                            currentDate = Calendar.current.date(byAdding: .day, value: 1, to: currentDate) ?? currentDate
                        }
                    }) {
                        Image(systemName: "chevron.right")
                            .font(.system(size: 50))
                    }
                }
                .padding()
                .background(.accent2.opacity(0.5))
                .cornerRadius(15)
                .shadow(radius: 5)
                .padding()

                Spacer()

                ZStack {
                    if !words.isEmpty {
                        WordCardView(
                            word: words[currentWordIndex].word,
                            definition: words[currentWordIndex].definition,
                            showDef: showDef,
                            onTap: { showDef.toggle() }
                        )
                        .id(currentWordIndex)
                    } else {
                        Text("Loading...")
                    }
                }
                .onAppear {
                    loadWords()
                }

                Spacer()
            }
        }
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

struct WordCardView: View {
    let word: String
    let definition: String
    let showDef: Bool
    let onTap: () -> Void

    var body: some View {
        VStack(spacing: 10) {
            Text(word)
                .font(.system(size: 70))
                .bold()
                .foregroundColor(.accentColor)
                .lineLimit(1)
                .minimumScaleFactor(0.2)
            if showDef {
                Text(definition)
                    .font(.system(size: 40))
                    .foregroundColor(.accent)
                    .multilineTextAlignment(.center)
                    .minimumScaleFactor(0.2)
                    .transition(.move(edge: .bottom).combined(with: .opacity))
            } else {
                Text("Tap to reveal definition")
                    .font(.subheadline)
                    .transition(.opacity)
            }
        }
        .padding(30)
        .background(.accent2.opacity(0.5))
        .cornerRadius(16)
        .shadow(radius: 5)
        .padding(15)
        .onTapGesture {
            withAnimation(.easeInOut(duration: 0.3)) {
                onTap()
            }
        }
    }
}

#Preview {
    ContentView()
}
