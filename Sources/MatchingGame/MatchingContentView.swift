import AVFoundation
import SwiftUI

public struct MatchingContentView: View {
  public init(squareSize: CGFloat) {
    self.squareSize = squareSize
  }

  @Environment(\.dismiss) var dismiss

  let squareSize: CGFloat

  @State private var isFinished = false

  public var body: some View {
    GeometryReader { geometry in
      let columns = getColumns(geometry)
      let count = getCount(geometry, columns)
      let emojis = Array(emojis.shuffled().prefix(upTo: count / 2))
      MatchingGrid(columns: columns, characters: emojis, isFinished: $isFinished)
    }
    .onChange(of: isFinished) {
      isFinished = false
    }
    .onLongPressGesture {
      dismiss()
    }
  }

  func getColumns(_ geometry: GeometryProxy) -> Int {
    let availableWidth = geometry.size.width - MatchingGrid.margin
    let square = squareSize + MatchingGrid.margin
    return max(Int(floor(availableWidth / square)), 1)
  }

  func getCount(_ geometry: GeometryProxy, _ columns: Int) -> Int {
    let availableHeight = geometry.size.height - MatchingGrid.margin
    let square = columns > 1 ? squareSize + MatchingGrid.margin : geometry.size.width - 2 * MatchingGrid.margin
    let count = Int(floor(availableHeight / square)) * columns
    return count % 2 == 0 ? count : count - 1
  }
}
