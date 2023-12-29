//
//  EmojiView.swift
//
//
//  Created by Simon Bromberg on 2023-12-29.
//

import SwiftUI

struct EmojiView: View {
  let character: Character

  var body: some View {
    GeometryReader { geometry in
      Text(String(character))
        .font(.system(size: geometry.largestDimension * 0.8))
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
  }
}

extension GeometryProxy {
  var largestDimension: CGFloat {
    max(size.height, size.width)
  }
}
