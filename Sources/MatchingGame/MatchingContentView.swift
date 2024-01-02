import AVFoundation
import SwiftUI

public struct MatchingContentView<M: Matchable>: View {
  public init(matchables: [M]) {
    self.matchables = matchables
  }

  @Environment(\.dismiss) var dismiss

  let matchables: [M]

  @State private var isFinished = false

  public var body: some View {
    GeometryReader { geometry in
      let (cols, rows, size) = getGridSize(geometry)
      let count = cols * rows
      let matchablesSubset = Array(matchables.shuffled().prefix(count / 2))

      MatchingGrid(columns: cols, size: size, matchables: matchablesSubset, isFinished: $isFinished)
    }
    .onChange(of: isFinished) {
      isFinished = false
    }
    .onLongPressGesture {
      dismiss()
    }
  }

  func getGridSize(_ geometry: GeometryProxy) -> (Int, Int, CGFloat) {
    let availableWidth = geometry.size.width - .margin * 2
    let availableHeight = geometry.size.height - .margin * 2
    let area = availableWidth * availableHeight

    var tileSize = max(sqrt(area / CGFloat(matchables.count * 2)), 50) // TODO: handle case with zero elements
    var cols = Int(floor(availableWidth / tileSize))
    var rows = Int(floor(availableHeight / tileSize))

    // Must have even number of tiles, if both xrows and cols are odd then tile count will be odd
    if cols % 2 != 0 && rows % 2 != 0 {
      if cols > rows {
        cols -= 1
      } else {
        rows -= 1
      }
    }
    
    let extraHorizontal = (availableWidth - tileSize * CGFloat(cols)) / CGFloat(cols)
    let extraVertical = (availableHeight - tileSize * CGFloat(rows)) / CGFloat(rows)

    tileSize += min(extraHorizontal, extraVertical) - .margin // TODO: figure out margin incorporation

    return (cols, rows, tileSize)
  }
}

extension CGFloat {
  static let margin: Self = 10
}
