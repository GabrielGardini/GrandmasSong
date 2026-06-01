import SwiftUI

struct IntroductionScene: View {
    @State private var pressedKeys: [String] = []
    @State private var nextScene: Bool = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                Image("background")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea(edges: .all)
                GeometryReader { geometry in
                    
                    VStack(alignment: .center) {
                        Spacer()          
                        ChatBox(
                            lines: [
                                String(localized: "dialogue.introduction")
                            ],
                            character: .boy,
                            boxSize: geometry.size.height * (2/9),
                            nextScene: $nextScene,
                            nextSceneBlocked: false
                        )
                        Spacer()
                            .frame(height: DeviceLayout.sceneBottomPadding(for: geometry))
                    }
                    .frame(maxWidth: .infinity)
                }
                .navigationBarBackButtonHidden(true)
            }
            .navigationDestination(isPresented: $nextScene) {
                GrandmaScene()
            }
        }
    }
    
}
