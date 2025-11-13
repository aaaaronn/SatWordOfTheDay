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
        Text("GIRASJIRJDAIO")
            .font(.title)
        Button("Close") {
            dismiss()
        }
        .background(.accent)
    }
}
