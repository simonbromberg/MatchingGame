import AVFoundation
import SwiftUI

struct MatchingGrid: View {
  let columns: Int
  let characters: [Character]
  let columnLayout: [GridItem]

  @Binding var isFinished: Bool
  @State private var selection = Selection()
  @State private var matched: Set<Character> = []

  init(columns: Int, characters: [Character], isFinished: Binding<Bool>) {
    self.columns = columns
    self.characters = (characters + characters).shuffled()
    columnLayout = .init(repeating: GridItem(), count: columns)
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

  static let margin: CGFloat = 10

  var body: some View {
    LazyVGrid(columns: columnLayout, spacing: Self.margin) {
      ForEach(0..<characters.count, id: \.self) { index in
        TileButton(
          isOn: Binding(
            get: {
              self.selection.contains(index) ||
                self.matched.contains(characters[index])
            },
            set: { _, _ in
              guard !selection.contains(index),
                    !selection.isFull,
                    !matched.contains(characters[index])
              else {
                return
              }
              let character = characters[index]

              var delayForSelectionReset: TimeInterval = 1

              if let selection = selection.first {
                if character == characters[selection] {
                  matched.insert(character)
                  DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    playMatchSound()
                    if matched.count >= characters.count / 2 {
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
          character: characters[index]
        )
      }
    }.padding(Self.margin).background()
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
    MatchingGrid(columns: 2, characters: Array(emojis.shuffled().prefix(upTo: 2)), isFinished: .constant(false))
      .previewLayout(.sizeThatFits)
  }
}
