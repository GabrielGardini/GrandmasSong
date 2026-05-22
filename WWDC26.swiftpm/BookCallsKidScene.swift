//
//  BookCallsKidScene.swift
//  WWDC26
//
//  Created by Gabriel Gardini on 04/02/26.
//

import SwiftUI

struct BookCallsKidScene: View {
    @State private var pressedKeys: [String] = []
    @State private var nextScene: Bool = false
    @State private var backgroundFrame: Int = 1

    private let totalBackgroundFrames = 7
    private let backgroundTimer = Timer.publish(every: 0.15, on: .main, in: .common).autoconnect()
    
    var body: some View {
        NavigationStack {
            ZStack {
                Image("houseBackgroundBookShining\(backgroundFrame)")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea(edges: .all)
                GeometryReader { geometry in
                    
                    VStack(alignment: .center) {
                        Spacer()                                       
                        ChatBox(
                            lines: [
                                "Hey kid, over here!"
                                
                            ],
                            character: .book,
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
                
                .onReceive(backgroundTimer) { _ in
                    backgroundFrame = backgroundFrame % totalBackgroundFrames + 1
                }
                .onAppear { backgroundFrame = 1 }
                .onDisappear { backgroundFrame = 1 }
                
                }
            
            .navigationDestination(isPresented: $nextScene) {
                BookSpeakingScene()
            }
            
        }
    }
    
}
