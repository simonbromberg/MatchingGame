//
//  Matchable.swift
//  
//
//  Created by Simon Bromberg on 2023-12-29.
//

import SwiftUI

public protocol Matchable: Hashable {
  associatedtype Body: View
  var content: Body { get }
}

extension Character: Matchable {
  public var content: some View {
    EmojiView(character: self)
  }
}

extension UIImage: Matchable {
  public var content: some View {
    Image(uiImage: self)
      .resizable()
      .aspectRatio(contentMode: .fit)
  }
}
