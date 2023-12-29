import SwiftUI

struct TileView<M: Matchable>: View {
  @Binding var isOn: Bool
  @State private var angle: Double = 0
  private var color: Color {
    isOn ? .yellow : .green
  }

  let matchable: M

  var body: some View {
    ZStack(alignment: .center) {
      RoundedRectangle(cornerRadius: 4)
        .aspectRatio(1, contentMode: ContentMode.fit)
        .foregroundColor(color)
        .onChange(of: isOn) {
          angle = isOn ? 180 : 0
        }
      matchable.content
        .opacity(isOn ? 1 : 0)
    }
    .rotation3DEffect(
      Angle(degrees: angle),
      axis: (x: 0, y: 1, z: 0)
    )
    .animation(.easeInOut, value: angle)
  }
}

struct TileView_Previews: PreviewProvider {
  static var previews: some View {
    TileView(isOn: .constant(true), matchable: Character("💩"))
      .previewLayout(.fixed(width: 100, height: 100))
  }
}
