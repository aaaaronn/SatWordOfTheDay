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
                colors: [.accent3, .accent4],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack {
                Text("GIRASJIRJDAIO")
                    .font(.title)
                Button("Close") {
                    dismiss()
                }
                .background(.accent)
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                    }
                }
            }
        }
    }
}
