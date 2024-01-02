//
//  ContentView.swift
//  MatchingGameExample
//
//  Created by Simon Bromberg on 2023-12-29.
//

import MatchingGame
import SwiftUI

struct ContentView: View {
  @State private var showingSheet = false
  @State private var count: Double = 10

  // TODO: calculate reasonable max

  var body: some View {
    VStack {
      Text("\(count, format: .number) tiles")
      Slider(
        value: $count,
        in: 1...Double(Character.emojis.count),
        step: 1
      )
      Button("Start") {
        showingSheet = true
      }
      .fullScreenCover(isPresented: $showingSheet) {
        MatchingContentView(
          matchables: Array(
            Character.emojis
              .shuffled()
              .prefix(
                Int(count)
              )
          )
        )
      }
    }
    .padding()
  }
}

#Preview {
  ContentView()
}
