import AVFoundation
import SwiftUI

struct TileButton: View {
  @Binding var isOn: Bool
  let character: Character

  var body: some View {
    Button {
      if !isOn {
        playSound()
      }
      isOn.toggle()
    } label: {
      TileView(isOn: $isOn, character: character)
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
    TileButton(isOn: .constant(true), character: "💩")
      .previewLayout(.fixed(width: 100, height: 100))
    TileButton(isOn: .constant(false), character: "💩")
      .previewLayout(.fixed(width: 100, height: 100))
  }
}
