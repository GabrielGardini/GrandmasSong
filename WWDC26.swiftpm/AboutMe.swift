import SwiftUI

struct AboutMe: View {
    @Environment(\.dismiss) private var dismiss
    @State private var pressedKeys: [String] = []
    @State private var nextScene: Bool = false
    
    var body: some View {
        NavigationStack {
            GeometryReader { geometry in
                ZStack {
                    Image("aboutme")
                        .resizable()
                        .scaledToFill()
                        .ignoresSafeArea(edges: .all)
                    
                    // Card size adapts to device: on iPhone uses the
                    // shorter screen dimension so the card never overflows
                    // in landscape; on iPad keeps the original 400 pt size.
                    let cardSize = DeviceLayout.aboutCardSize(for: geometry)
                    let cardFontSize: CGFloat = DeviceLayout.isPhone ? 22 : 30

                    Rectangle()
                        .fill(Color.white.opacity(0.1))
                        .frame(width: cardSize, height: cardSize)
                        .overlay(
                            VStack(spacing: 12) {
                                Text("aboutme.title", bundle: .main)
                                    .font(.custom("VT323-Regular", size: cardFontSize))
                                    .fontWeight(.semibold)
                                    .foregroundStyle(.black)

                                Text("aboutme.description", bundle: .main)
                                    .font(.custom("VT323-Regular", size: cardFontSize))
                                    .multilineTextAlignment(.center)
                                    .foregroundStyle(.black)
                                    .padding(.horizontal, 16)
                            }
                            .padding()
                        )
                        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                        .shadow(radius: 8)
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                        // On iPhone the card stays centred; on iPad it shifts to
                        // align with the background character art.
                        .offset(
                            x: DeviceLayout.aboutCardOffsetX(for: geometry),
                            y: DeviceLayout.aboutCardOffsetY(for: geometry)
                        )
                }
            }
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button(action: { dismiss() }) {
                        Image("chatbox-button")
                            .renderingMode(.original)
                            .resizable()
                            .scaledToFit()
                            .frame(height: 40)
                            .accessibilityLabel(Text("accessibility.back", bundle: .main))
                            .rotation3DEffect(.degrees(180), axis: (x: 0, y: 1, z: 0))

                    }
                }
            }
        }
    }
    
}
