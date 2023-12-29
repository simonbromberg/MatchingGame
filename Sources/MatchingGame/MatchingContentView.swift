import AVFoundation
import SwiftUI

public struct MatchingContentView<M: Matchable>: View {
  public init(matchables: [M], squareSize: CGFloat) {
    self.matchables = matchables
    self.squareSize = squareSize
  }

  @Environment(\.dismiss) var dismiss

  let squareSize: CGFloat

  let matchables: [M]

  @State private var isFinished = false

  public var body: some View {
    GeometryReader { geometry in
      let columns = getColumns(geometry)
      let count = getCount(geometry, columns)
      let emojis = Array(matchables.shuffled().prefix(upTo: count / 2))
      MatchingGrid(columns: columns, matchables: emojis, isFinished: $isFinished)
    }
    .onChange(of: isFinished) {
      isFinished = false
    }
    .onLongPressGesture {
      dismiss()
    }
  }

  func getColumns(_ geometry: GeometryProxy) -> Int {
    let availableWidth = geometry.size.width - .margin
    let square = squareSize + .margin
    return max(Int(floor(availableWidth / square)), 1)
  }

  func getCount(_ geometry: GeometryProxy, _ columns: Int) -> Int {
    let availableHeight = geometry.size.height - .margin
    let square = columns > 1 ? squareSize + .margin : geometry.size.width - 2 * .margin
    let count = Int(floor(availableHeight / square)) * columns
    return count % 2 == 0 ? count : count - 1
  }
}

extension CGFloat {
  static let margin: Self = 10
}
