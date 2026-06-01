//
//  PianoFocusedScene.swift
//  WWDC26
//
//  Created by Gabriel Gardini on 05/02/26.
//

import SwiftUI

struct PianoFocusedScene: View {
    @State private var pressedKeys: [String] = []
    @State private var nextScene: Bool = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                Image("lookAtPiano")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea(edges: .all)
                GeometryReader { geometry in
                    
                    VStack(alignment: .center) {
                        Spacer()          
                        ChatBox(
                            lines: [
                                String(localized: "dialogue.pianoFocused.line1"),
                                String(localized: "dialogue.pianoFocused.line2")
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
                FirstPianoPlayingScene()
            }
            
        }
    }
    
}
