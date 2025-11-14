//
//  KnownView.swift
//  SatWordOfTheDay
//
//  Created by akramp on 11/12/25.
//

import SwiftUI

struct KnownView: View {
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ZStack {
            LinearGradient(
                colors: [.accent4, .accent3],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack {
                Text("GIRASJIRJDAIO")
                    .font(.title)
                Button() {
                    dismiss()
                } label: {
                    Image(systemName: "xmark.circle.fill")
                }
                //.background(.accent)
            }
            .navigationTitle("Known Words")
        }
    }
}

#Preview {
    KnownView()
}
