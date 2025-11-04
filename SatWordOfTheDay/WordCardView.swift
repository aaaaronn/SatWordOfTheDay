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
        }
        .padding(30)
        //.frame(maxWidth: 200)
        //.accent4.opacity(0.8)
        .background(.accent4.opacity(0.8))
            
        
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
    WordCardView(word: "Word", definition: "define the word")
}
