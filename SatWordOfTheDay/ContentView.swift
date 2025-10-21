//
//  ContentView.swift
//  SatWordOfTheDay
//
//  Created by akramp on 10/3/25.
//

import SwiftUI
import WidgetKit //refresh

struct ContentView: View {
    // Persist known words as JSON Data
    @AppStorage("KnownWords") private var knownWordsData: Data = Data()
    
    // Helper methods to decode/encode known words
    private func getKnownWords() -> [SATWord] {
        guard !knownWordsData.isEmpty,
              let decoded = try? JSONDecoder().decode([SATWord].self, from: knownWordsData)
        else { return [] }
        return decoded
    }
    
    private func setKnownWords(_ newValue: [SATWord]) {
        knownWordsData = (try? JSONEncoder().encode(newValue)) ?? Data()
        // Optionally refresh widget timelines when known words change
        WidgetCenter.shared.reloadAllTimelines()
    }
    
    // UI state
    @State private var startingDayIndex = 0
    @State private var visualWordIndex = 0
    @State private var selectedWordIndex: Int?
    @State private var isSyncing = false
    @State private var words: [SATWord] = []
    @State private var showKnownWords = false

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
                        .foregroundColor(.accent2)
                    
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
                .background(.accent3.opacity(0.5))
                .cornerRadius(15)
                .shadow(radius: 5)
                .padding()

                Spacer()

                ScrollViewReader { scrollProxy in
                    ScrollView(.horizontal, showsIndicators: false) {
                        LazyHStack(spacing: 32) {
                            ForEach(words.indices, id: \.self) { i in
                                let word = words[i]
                                WordCardView(
                                    word: word.word,
                                    definition: word.definition,
                                    isKnown: getKnownWords().contains(word),
                                    onMarkKnown: {
                                        markKnown(word)
                                    }
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
                    WidgetCenter.shared.reloadAllTimelines()
                    loadWords()
                }

                Spacer()
                
                // Button to view known words grid
                Button {
                    showKnownWords = true
                } label: {
                    HStack {
                        Image(systemName: "checkmark.seal.fill")
                        Text("View Known Words")
                            .bold()
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(.accent3.opacity(0.5))
                    .foregroundColor(.accent2)
                    .cornerRadius(12)
                    .padding(.horizontal)
                }
                .sheet(isPresented: $showKnownWords) {
                    KnownWordsView(
                        knownWords: getKnownWords(),
                        onRemove: { word in
                            removeKnown(word)
                        }
                    )
                }
                .padding(.bottom)
            }
        }
    }

    func loadWords() {
        let all = GetSATWords()
        // Filter out known words from the main list
        let known = getKnownWords()
        let filtered = all.filter { !known.contains($0) }
        self.words = filtered
        
        if !words.isEmpty {
            showWordOfTheDay()
        } else {
            // If all words are known, you could either show nothing or show a message
            startingDayIndex = 0
            visualWordIndex = 0
        }
    }

    func showWordOfTheDay() {
        let dayOfYear = Calendar.current.ordinality(of: .day, in: .year, for: Date()) ?? 1
        startingDayIndex = words.isEmpty ? 0 : (dayOfYear % words.count)
    }
    
    func markKnown(_ word: SATWord) {
        var current = getKnownWords()
        if !current.contains(word) {
            current.append(word)
            setKnownWords(current)
            // Update the visible words to exclude the newly known word
            loadWords()
        }
    }
    
    func removeKnown(_ word: SATWord) {
        var current = getKnownWords()
        if let idx = current.firstIndex(of: word) {
            current.remove(at: idx)
            setKnownWords(current)
            // Optionally refresh the main list if you want to re-include it
            loadWords()
        }
    }
}

struct WordCardView: View {
    let word: String
    let definition: String
    let isKnown: Bool
    let onMarkKnown: () -> Void

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
                    .foregroundColor(.accent2)
                    .multilineTextAlignment(.center)
                    .minimumScaleFactor(0.2)
                    .transition(.move(edge: .bottom).combined(with: .opacity))
            } else {
                Text("Tap to reveal definition")
                    .font(.subheadline)
                    .foregroundColor(.accent2)
                    .transition(.slide.combined(with: .opacity))
            }
            
            Button {
                onMarkKnown()
            } label: {
                HStack {
                    Image(systemName: isKnown ? "checkmark.circle.fill" : "plus.circle")
                    Text(isKnown ? "Marked as Known" : "Mark as Known")
                        .bold()
                }
                .padding(.vertical, 8)
                .padding(.horizontal, 12)
                .background(isKnown ? Color.green.opacity(0.2) : Color.accent3.opacity(0.5))
                .foregroundColor(.accent2)
                .cornerRadius(10)
            }
            .disabled(isKnown)
        }
        .padding(30)
        .background(.accent3.opacity(0.5))
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
