//
//  BookSpeakingScene.swift
//  WWDC26
//
//  Created by Gabriel Gardini on 04/02/26.
//

import SwiftUI

struct BookSpeakingScene: View {
    @State private var pressedKeys: [String] = []
    @State private var nextScene: Bool = false
    
    @State private var bgFrameIndex: Int = 0
    @State private var bgTimer: Timer? = nil
    
    @State private var bgFrame: [String] = ["1","2","3","4","5","1","2","3","4","5","1","2","3","4","5","1","2","3","4","5", "6", "7", "8", "9", "10", "11", "12", "13", "14"]
    
    private var currentBackgroundName: String {
        "pianoBackground\(bgFrame[bgFrameIndex])"
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                Image(currentBackgroundName)
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
                                String(localized: "dialogue.bookSpeaking.line1"),
                                String(localized: "dialogue.bookSpeaking.line2"),
                                String(localized: "dialogue.bookSpeaking.line3"),
                                String(localized: "dialogue.bookSpeaking.line4")
                                
                            ],
                            character: .none,
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
            .onAppear {
                bgTimer?.invalidate()
                bgTimer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
                    Task { @MainActor in
                        if bgFrameIndex >= bgFrame.count - 1 {
                            bgFrameIndex = 0
                        } else {
                            bgFrameIndex += 1
                        }
                    }
                }
            }
            .onDisappear {
                bgTimer?.invalidate()
                bgTimer = nil
            }
            .navigationDestination(isPresented: $nextScene) {
                BookTeachingScene()
            }
            
        }
    }
    
}
