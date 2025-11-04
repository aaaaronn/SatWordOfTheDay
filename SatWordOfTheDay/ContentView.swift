//
//  ContentView.swift
//  SatWordOfTheDay
//
//  Created by akramp on 10/3/25.
//

import SwiftUI
import WidgetKit //refresh

struct ContentView: View {
    @Binding var words: [SATWord]
    @State private var startingDayIndex = 0
    @State private var visualWordIndex = 0
    @State private var selectedWordIndex: Int?
    @State private var isSyncing = false


    var body: some View {
        ZStack {
            LinearGradient(
                colors: [.accent3, .accent2],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
                .ignoresSafeArea()
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
                            .scaleEffect(UIDevice.current.userInterfaceIdiom == .pad ? 1.5 : 1)
                    
                        
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
                .background(.accent4.opacity(0.8))
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
                                .scaleEffect(UIDevice.current.userInterfaceIdiom == .pad ? 2.5 : 1)
                            }
                        }
                        .scrollTargetLayout()
                    }
                    .safeAreaPadding(.horizontal, 32)
                    .scrollPosition(id: $selectedWordIndex)
                    // hopefully only runs once on load
                    .onChange(of: startingDayIndex) {
                        scrollProxy.scrollTo(startingDayIndex, anchor: .center)
                    }
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
                    startingDayIndex = words.count / 2
                    visualWordIndex = startingDayIndex
                }

                Spacer()
            }
        }
    }
}

#Preview {
    @Previewable @State var word = GetSATWords()
    ContentView(words: $word)
}
