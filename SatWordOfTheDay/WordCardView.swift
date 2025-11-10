//
//  WordCardView.swift
//  SatWordOfTheDay
//
//  Created by akramp on 11/2/25.
//
import SwiftUI

struct WordCardView: View {
    let word: String
    let definition: String

    @State private var showDef: Bool = false
    @State private var isKnown: Bool = false

    var body: some View {
        VStack(spacing: 10) {
            Text(word)
                .font(.system(size: 50))
                .fontWeight(.heavy)
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
            HStack {
                //Color.clear.frame(width:66, height: 1)
                
                Button(action: {
                    withAnimation(.easeOut(duration: 0.3)) {
                        isKnown.toggle()
                    }
                }) {
                    if (isKnown) {
                        Text("Mark Learning")
                    } else {
                        Text("Mark Known")
                    }
                }
                .padding(5)
                .background(.accent3.opacity(0.4))
                .cornerRadius(5)
                .shadow(radius: 5, x: 5, y: 5)
            }
            .padding(.top, 6)
        }
        .padding(30)
        //.frame(maxWidth: 200)
        .background(.accent4.opacity(0.8))
            
        .cornerRadius(16)
        .shadow(radius: 5, x: 5, y: 5)
        .shadow(color: .white.opacity(0.5), radius: 3)
        .onTapGesture {
            withAnimation(.easeInOut(duration: 0.3)) {
                showDef.toggle()
            }
        }
    }
}

#Preview {
    WordCardView(word: "word", definition: "wordy wordestiesd that words")
}
