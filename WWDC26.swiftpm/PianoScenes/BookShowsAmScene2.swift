//
//  BookShowsAmScene2.swift
//  WWDC26
//
//  Created by Gabriel Gardini on 04/02/26.
//

import SwiftUI

struct BookShowsAmScene2: View {
    @State private var pressedKeys: [String] = []
    @State private var nextScene: Bool = false
    
    @State private var keyVectors: [[Bool]] = [[true, true, true, true, true, true, true, true, true, false, true, true, false, true, true, true, false],
    ]
    @State private var currentVectorIndex: Int = 0
    @State private var activeKeys: [Bool] = []
    
    @State private var bgFrameIndex: Int = 0
    @State private var bgTimer: Timer? = nil
    
    @State private var showNotes: Bool = false
    @State private var notesSuffixSequence: [Int] = [1, 2, 3, 3, 2, 1]
    @State private var notesIndex: Int = 0
    @State private var notesTimer: Timer? = nil
    @State private var hasTriggeredNotes: Bool = false
    
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
                            .overlay{
                                if showNotes {
                                    Image("notes\(notesSuffixSequence[notesIndex])")
                                        .resizable()
                                        .scaledToFill()
                                }
                            }
                        HStack(alignment: .top, spacing: 0) {
                            
                            PianoView(width: geometry.size.width, height: geometry.size.height, pressedKeys: $pressedKeys, disabledKeys: activeKeys)
                            
                        }
                        
                        ChatBox(
                            lines: [
                                String(localized: "dialogue.bookShowsAm.line2")
                                
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
                    .onAppear {
                        if activeKeys.isEmpty, let first = keyVectors.first {
                            activeKeys = first
                        }
                    }
                    .onChange(of: pressedKeys) { newValue in
                        if !hasTriggeredNotes && !newValue.isEmpty {
                            hasTriggeredNotes = true
                            startNotesAnimation()
                        }
                        if ["a4", "c4", "e4"].allSatisfy(newValue.contains) {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.9) {
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
                notesTimer?.invalidate()
                notesTimer = nil
            }
            .navigationDestination(isPresented: $nextScene) {
                BookShowsGScene1()
            }
            
        }
    }
    
    private func startNotesAnimation() {
        notesTimer?.invalidate()
        notesIndex = 0
        showNotes = true
        
        notesTimer = Timer.scheduledTimer(withTimeInterval: 0.12, repeats: true) { _ in
            Task { @MainActor in
                if notesIndex >= notesSuffixSequence.count - 1 {
                    // End of animation
                    notesTimer?.invalidate()
                    notesTimer = nil
                    // Small delay to ensure last frame is visible briefly
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
                        showNotes = false
                    }
                } else {
                    notesIndex += 1
                }
            }
        }
    }
    
}

