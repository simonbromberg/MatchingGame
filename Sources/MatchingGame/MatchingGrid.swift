import AVFoundation
import SwiftUI

struct MatchingGrid<M: Matchable>: View {
  let columns: Int
  let matchables: [M]
  let columnLayout: [GridItem]

  @Binding var isFinished: Bool
  @State private var selection = Selection()
  @State private var matched: Set<M> = []

  init(columns: Int, size: CGFloat, matchables: [M], isFinished: Binding<Bool>) {
    self.columns = columns
    self.matchables = (matchables + matchables).shuffled()
    columnLayout = size != .zero ? .init(
      repeating: .init(.fixed(size)),
      count: columns
    ) : []
    _isFinished = isFinished
  }

  struct Selection {
    var first: Int?
    var second: Int?

    func contains(_ val: Int) -> Bool {
      first == val || second == val
    }

    var isFull: Bool {
      first != nil && second != nil
    }

    mutating func insert(_ val: Int) {
      if first == nil {
        first = val
      } else {
        second = val
      }
    }

    mutating func reset() {
      first = nil
      second = nil
    }
  }

  var body: some View {
    LazyVGrid(columns: columnLayout, spacing: .margin) {
      ForEach(0..<matchables.count, id: \.self) { index in
        TileButton(
          isOn: Binding(
            get: {
              self.selection.contains(index) ||
                self.matched.contains(matchables[index])
            },
            set: { _, _ in
              guard !selection.contains(index),
                    !selection.isFull,
                    !matched.contains(matchables[index])
              else {
                return
              }
              let matchable = matchables[index]

              var delayForSelectionReset: TimeInterval = 1

              if let selection = selection.first {
                if matchable == matchables[selection] {
                  matched.insert(matchable)
                  DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    playMatchSound()
                    if matched.count >= matchables.count / 2 {
                      playWinSound()

                      DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        isFinished = true
                        matched.removeAll(keepingCapacity: true)
                      }
                    }
                  }
                  delayForSelectionReset = 0
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + delayForSelectionReset) {
                  self.selection.reset()
                }
              }
              selection.insert(index)
            }
          ),
          isMatched: .constant(
            self.matched.contains(matchables[index])
          ),
          matchable: matchables[index]
        )
      }
    }.padding(.margin).background()
  }

  private func playMatchSound() {
    let systemSoundID: SystemSoundID = 1008
    AudioServicesPlaySystemSound(systemSoundID)
  }

  private func playWinSound() {
    let systemSoundID: SystemSoundID = 1009
    AudioServicesPlaySystemSound(systemSoundID)
  }
}

struct MatchingGrid_Previews: PreviewProvider {
  static var previews: some View {
    MatchingGrid(
      columns: 2,
      size: 100,
      matchables: Array(Character.emojis.shuffled().prefix(upTo: 2)),
      isFinished: .constant(false)
    )
    .previewLayout(.sizeThatFits)
  }
}
