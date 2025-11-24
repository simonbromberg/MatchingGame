import AVFoundation
import SwiftUI

struct TileButton<M: Matchable>: View {
  @Binding var isOn: Bool
  @Binding var isMatched: Bool

  let matchable: M

  var body: some View {
    Button {
      if !isOn {
        playSound()
      }
      isOn.toggle()
    } label: {
      TileView(isOn: $isOn, isMatched: $isMatched, matchable: matchable)
    }
    .buttonStyle(.plain)
  }

  func playSound() {
    let systemSoundID: SystemSoundID = 1016
    AudioServicesPlaySystemSound(systemSoundID)
  }
}

struct TileButton_Previews: PreviewProvider {
  static var previews: some View {
    TileButton(isOn: .constant(true), isMatched: .constant(false), matchable: Character.test)
      .previewLayout(.fixed(width: 100, height: 100))
    TileButton(isOn: .constant(false), isMatched: .constant(false), matchable: Character.test)
      .previewLayout(.fixed(width: 100, height: 100))
  }
}

extension Character {
  static let test: Character = "💩"
}
