//
//  PlayPianoScene.swift
//  WWDC26
//
//  Created by Gabriel Gardini on 04/02/26.
//

import SwiftUI

struct PlayPianoScene: View {
    @Environment(\.dismiss) private var dismiss

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
                        .padding(0)
                        ChatBox(
                            lines: [
                                "Let's try playing something!"
                            ],
                            character: .boy,
                            boxSize: geometry.size.height * (2/9),
                            nextScene: $nextScene,
                            nextSceneBlocked: true
                        )
                        .padding(0)
                        
                        Spacer()
                            .frame(height: geometry.size.height / 30)
                        
                    }
                    .frame(maxWidth: .infinity)
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
                BookShowsKeysScene()
            }
            
        }
    }
    
}
