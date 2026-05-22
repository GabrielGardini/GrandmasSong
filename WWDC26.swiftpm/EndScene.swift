//
//  EndScene.swift
//  WWDC26
//
//  Created by Gabriel Gardini on 05/02/26.
//

import SwiftUI

struct EndScene: View {
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
                        
                        VStack(spacing: 16) {
                            NavigationLink("Home", destination: { StartView() })
                                .buttonStyle(.borderedProminent)
                            NavigationLink("Keep Playing", destination: { PlayPianoScene() })
                                .buttonStyle(.borderedProminent)
                        }
                        .padding(.horizontal)
                        .frame(maxWidth: .infinity)
                                       
                        ChatBox(
                            lines: [
                                "Thank you so much! Now I know how to make grandma happy whenever she feels sad!"
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
                StartView()
            }
            
        }
    }
    
}
