//
//  WordWidgetExtension.swift
//  SatWordOfTheDay
//
//  Created by akramp on 10/15/25.
//

import WidgetKit
import SwiftUI

@main
struct WordWidgetExtension: Widget {
    let kind: String = "SATWordWidget"
    var body: some WidgetConfiguration {
        
        StaticConfiguration(
            kind: kind,
            provider: WordProvider(),
            content: {
                WordWidgetView(entry: $0)
            })
        .configurationDisplayName("SAT word")
        
        .description("An SAT word with its definition")
        
        .supportedFamilies([
            .systemSmall
        ])
    }
}
