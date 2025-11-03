//
//  LoadingView.swift
//  SatWordOfTheDay
//
//  Created by akramp on 11/2/25.
//
import SwiftUI

struct LoadingView: View {
    var body: some View {
        ZStack {
            Color.background.ignoresSafeArea()
            Text("Loading...")
        }
    }
}

#Preview {
    LoadingView()
}
