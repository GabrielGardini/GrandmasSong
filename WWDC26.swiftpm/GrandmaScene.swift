//
//  GrandmaScene.swift
//  WWDC26
//
//  Created by Gabriel Gardini on 04/02/26.
//

import SwiftUI
import AVFoundation

struct GrandmaScene: View {
    @State private var backgroundImages: [String] = ["younggrandma1", "younggrandma2", "younggrandma3"]
    @State private var currentImageIndex: Int = 0
    @State private var imageTimer: Timer? = nil
    @State private var audioPlayer: AVAudioPlayer? = nil
    @State private var audioSessionConfigured: Bool = false
    @State private var pressedKeys: [String] = []
    @State private var nextScene: Bool = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                Image(backgroundImages[currentImageIndex])
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea(edges: .all)
                GeometryReader { geometry in
                    
                    VStack(alignment: .center) {
                        Spacer()
                        ChatBox(
                            lines: [
                                String(localized: "dialogue.grandma.line1"),
                                String(localized: "dialogue.grandma.line2")
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
            .onAppear {
                // Configure audio session once to reduce startup latency
                if !audioSessionConfigured {
                    do {
                        let session = AVAudioSession.sharedInstance()
                        try session.setCategory(.ambient, mode: .default, options: [.mixWithOthers])
                        try session.setActive(true)
                        audioSessionConfigured = true
                    } catch {
                        print("Audio session setup failed:", error)
                    }
                }
                
                // Start cycling images every 0.4 seconds
                imageTimer?.invalidate()
                imageTimer = Timer.scheduledTimer(withTimeInterval: 0.4, repeats: true) { _ in
                    Task { @MainActor in
                        currentImageIndex = (currentImageIndex + 1) % backgroundImages.count
                    }
                }
                
                // Play audio named "youngGrandmaSong" (must be in the main bundle)
                if let existing = audioPlayer {
                    // If we already have a player, restart instantly from the beginning for zero delay
                    existing.currentTime = 0
                    existing.play()
                } else if let url = Bundle.main.url(forResource: "GrandmasSong", withExtension: "mp3") {
                    do {
                        let player = try AVAudioPlayer(contentsOf: url)
                        player.numberOfLoops = -1 // gapless-style looping for WAV
                        player.prepareToPlay()
                        player.currentTime = 0
                        player.volume = 0.8
                        player.play()
                        audioPlayer = player
                    } catch {
                        print("Failed to initialize AVAudioPlayer: \(error)")
                    }
                } else {
                    print("Audio file 'grandmasSong' not found in bundle.")
                }
            }
            .onDisappear {
                imageTimer?.invalidate()
                imageTimer = nil
                audioPlayer?.pause()
            }
            .navigationDestination(isPresented: $nextScene) {
                SadGrandmaScene()
            }
            
        }
    }
    
}
