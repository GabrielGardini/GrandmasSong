//
//  CheerUpScene.swift
//  WWDC26
//
//  Created by Gabriel Gardini on 05/02/26.
//

import SwiftUI

struct CheerUpScene: View {
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
                                "Today I wanted to cheer her up"
                            ],
                            character: .boy,
                            boxSize: geometry.size.height * (2/9),
                            nextScene: $nextScene,
                            nextSceneBlocked: false
                        )
                        Spacer()
                            .frame(height: geometry.size.height / 30)
                    }
                    .frame(maxWidth: .infinity)
                }
                .navigationBarBackButtonHidden(true)
                
                
                }
            .navigationDestination(isPresented: $nextScene) {
                PianoFocusedScene()
            }
            
        }
    }
    
}
