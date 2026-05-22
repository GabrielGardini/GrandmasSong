//
//  FirstPianoPlayingScene.swift
//  WWDC26
//
//  Created by Gabriel Gardini on 05/02/26.
//

import SwiftUI

struct FirstPianoPlayingScene: View {
    @State private var pressedKeys: [String] = []
    @State private var nextScene: Bool = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                Image("pianoBackgroundNoBook")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea(edges: .all)
                GeometryReader { geometry in
                    
                    VStack(alignment: .center) {
                        Spacer()
                        HStack(alignment: .top, spacing: 0) {

                            PianoView(width: geometry.size.width, height: geometry.size.height, pressedKeys: $pressedKeys, disabledKeys: Array(repeating: false, count: 17))

                        }
                                       
                        ChatBox(
                            lines: [
                                "Let's try playing some keys! Could you help me play them?"
                            ],
                            character: .boy,
                            boxSize: geometry.size.height * (2/9),
                            nextScene: $nextScene,
                            nextSceneBlocked: true
                        )
                        Spacer()
                            .frame(height: geometry.size.height / 30)
                    }
                    .frame(maxWidth: .infinity)
                    .onChange(of: pressedKeys) { newValue in
                        if pressedKeys.count >= 5 {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                nextScene = true
                            }
                        }
                    }
                }
                .navigationBarBackButtonHidden(true)
                }
            .navigationDestination(isPresented: $nextScene) {
                BookCallsKidScene()
            }
            
        }
    }
    
}
