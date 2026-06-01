//
//  BookShowsKeysScene.swift
//  WWDC26
//
//  Created by Gabriel Gardini on 04/02/26.
//

import SwiftUI

struct BookShowsKeysScene: View {
    @State private var pressedKeys: [String] = []
    @State private var nextScene: Bool = false
    
    @State private var keyVectors: [[Bool]] = []
    @State private var currentVectorIndex: Int = 0
    @State private var activeKeys: [Bool] = Array(repeating: false, count: 17)
    
    @State private var bgFrameIndex: Int = 0
    @State private var bgTimer: Timer? = nil
    
    @State private var bgFrame: [String] = ["1","2","3","4","5","1","2","3","4","5","1","2","3","4","5","1","2","3","4","5", "6", "7", "8", "9", "10", "11", "12", "13", "14"]
    
    private var currentBackgroundName: String {
        "pianoBackground\(bgFrame[bgFrameIndex])"
    }
    
    init() {
        let totalKeys = 17
        var vectors: [[Bool]] = []
        for i in 0..<totalKeys {
            var v = Array(repeating: false, count: totalKeys)
            v[i] = true
            vectors.append(v)
        }
        _keyVectors = State(initialValue: vectors)
        _activeKeys = State(initialValue: vectors.first ?? Array(repeating: false, count: totalKeys))
        _currentVectorIndex = State(initialValue: 0)
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
                            
                            PianoWhenTeachingView(width: geometry.size.width, height: geometry.size.height, pressedKeys: $pressedKeys, disabledKeys: activeKeys.map { !$0 })
                            
                        }
                        
                        ChatBox(
                            lines: [
                                String(localized: "dialogue.bookShowsKeys")
                                
                            ],
                            character: .none,
                            boxSize: geometry.size.height * (2/9),
                            nextScene: $nextScene,
                            nextSceneBlocked: true
                        )
                        Spacer()
                            .frame(height: DeviceLayout.sceneBottomPadding(for: geometry))
                    }
                    .frame(maxWidth: .infinity)
                    .onChange(of: pressedKeys) { newValue in
                        if !newValue.isEmpty {
                            let total = keyVectors.count
                            if total > 0 {
                                if currentVectorIndex < total - 1 {
                                    let nextIndex = currentVectorIndex + 1
                                    activeKeys = keyVectors[nextIndex]
                                    currentVectorIndex = nextIndex
                                } else {
                                    activeKeys = keyVectors[currentVectorIndex]
                                }
                            }
                        }
                        if pressedKeys.contains("e4"){
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                nextScene = true
                            }
                        }
                    }
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
                BookExplainingChordsScene()
            }
            
        }
    }
    
}
