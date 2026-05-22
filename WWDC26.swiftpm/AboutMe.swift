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
                    
                    Rectangle()
                        .fill(Color.white.opacity(0.1))
                        .frame(width: 400, height: 400)
                        .overlay(
                            VStack(spacing: 12) {
                                Text("About Me")
                                    .font(.custom("VT323-Regular", size: 30))
                                    .fontWeight(.semibold)
                                    .foregroundStyle(.black)

                                Text("Hello, I’m Gabriel! I’m an iOS developer passionate about music and my grandma. In Grandma’s Song, you’ll learn a bit more about the piano and how music can help in cases of dementia and Alzheimer’s.")
                                    .font(.custom("VT323-Regular", size: 30))
                                    .multilineTextAlignment(.center)
                                    .foregroundStyle(.black)
                                    .padding(.horizontal, 16)
                            }
                            .padding()
                        )
                        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                        .shadow(radius: 8)
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                        .offset(x: geometry.size.width / 4.5, y: -geometry.size.width / 13)
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
                            .accessibilityLabel("Voltar")
                            .rotation3DEffect(.degrees(180), axis: (x: 0, y: 1, z: 0))

                    }
                }
            }
        }
    }
    
}
