//
//  ContentView.swift
//  SatWordOfTheDay
//
//  Created by akramp on 10/3/25.
//

import SwiftUI

struct SATWord: Decodable, Equatable {
    let word: String
    let definition: String
}

struct ContentView: View {
    @State private var startingDayIndex = 0
    @State private var visualWordIndex = 0
    @State private var selectedWordIndex: Int?
    @State private var isSyncing = false

    @State private var words: [SATWord] = []

    var body: some View {
        ZStack {
            Color.background.ignoresSafeArea()
            VStack {
                HStack() {
                        Button(action: {
                            if visualWordIndex > 0 {
                                visualWordIndex -= 1
                            }
                        }) {
                            Image(systemName: "chevron.left")
                                .font(.system(size: 50))
                        }
                        
                        Spacer()
                        
                        Text(Calendar.current.date(byAdding: .day, value: visualWordIndex - startingDayIndex, to: Date()) ?? Date(), style: .date)
                        .font(.system(size: 25))
                            .bold()
                            .foregroundColor(.accent3)
                        
                        Spacer()
                        
                        Button(action: {
                            if visualWordIndex < words.count - 1 {
                                visualWordIndex += 1
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

                ScrollViewReader { scrollProxy in
                    ScrollView(.horizontal, showsIndicators: false) {
                        LazyHStack(spacing: 32) {
                            ForEach(words.indices, id: \.self) { i in
                                WordCardView(
                                    word: words[i].word,
                                    definition: words[i].definition
                                )
                                .containerRelativeFrame(.horizontal, count: 1, span: 1, spacing: 0)
                                .id(i)
                            }
                        }
                        .scrollTargetLayout()
                    }
                    .safeAreaPadding(.horizontal, 32)
                    .onChange(of: words) {
                        if !words.isEmpty {
                            scrollProxy.scrollTo(startingDayIndex, anchor: .center)
                            visualWordIndex = startingDayIndex
                        }
                    }
                    .scrollPosition(id: $selectedWordIndex)
                    .onChange(of: selectedWordIndex) {
                        if let index = selectedWordIndex {
                            isSyncing = true
                            visualWordIndex = index
                        }
                    }
                    .onChange(of: visualWordIndex) {
                        // only animate from arrows
                        if isSyncing {
                            isSyncing = false
                            return
                        }
                        withAnimation {
                            scrollProxy.scrollTo(visualWordIndex, anchor: .center)
                        }
                    }
                }
                .scrollTargetBehavior(.viewAligned)
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

        startingDayIndex = dayOfYear % words.count
    }
}

struct WordCardView: View {
    let word: String
    let definition: String

    @State private var showDef: Bool = false

    var body: some View {
        VStack(spacing: 10) {
            Text(word)
                .font(.system(size: 50))
                .bold()
                .foregroundColor(.accentColor)
                .lineLimit(1)
                .minimumScaleFactor(0.2)
            if showDef {
                Text(definition)
                    .font(.system(size: 30))
                    .foregroundColor(.accent3)
                    .multilineTextAlignment(.center)
                    .minimumScaleFactor(0.2)
                    .transition(.move(edge: .bottom).combined(with: .opacity))
            } else {
                Text("Tap to reveal definition")
                    .font(.subheadline)
                    .foregroundColor(.accent3)
                    .transition(.slide.combined(with: .opacity))
            }
        }
        .padding(30)
        //.frame(maxWidth: 200)
        .background(.accent2.opacity(0.5))
        .cornerRadius(16)
        .shadow(radius: 5)
        .onTapGesture {
            withAnimation(.easeInOut(duration: 0.3)) {
                showDef.toggle()
            }
        }
    }
}

#Preview {
    ContentView()
}
