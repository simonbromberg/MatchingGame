import SwiftUI

struct TileView: View {
  @Binding var isOn: Bool
  @State private var angle: Double = 0
  private var color: Color {
    isOn ? .yellow : .green
  }

  let character: Character

  var body: some View {
    ZStack(alignment: .center) {
      RoundedRectangle(cornerRadius: 4)
        .aspectRatio(1, contentMode: ContentMode.fit)
        .foregroundColor(color)
        .onChange(of: isOn) {
          angle = isOn ? 180 : 0
        }
      EmojiView(character: character)
        .opacity(isOn ? 1 : 0)
    }
    .rotation3DEffect(
      Angle(degrees: angle),
      axis: (x: 0, y: 1, z: 0)
    )
    .animation(.easeInOut, value: angle)
  }
}

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

struct TileView_Previews: PreviewProvider {
  static var previews: some View {
    TileView(isOn: .constant(true), character: "💩")
      .previewLayout(.fixed(width: 100, height: 100))
  }
}
