//
//  EndScene.swift
//  WWDC26
//
//  Created by Gabriel Gardini on 05/02/26.
//

import SwiftUI
import AVFAudio

struct GabrielThanksScene: View {
    @State private var pressedKeys: [String] = []
    @State private var nextScene: Bool = false
    @State private var audioPlayer: AVAudioPlayer?
    @State private var backgroundFrame: Int = 1

    private let totalBackgroundFrames = 8
    private let backgroundTimer = Timer.publish(every: 0.3, on: .main, in: .common).autoconnect()

    private func startLoopingAudio() {
        guard let url = Bundle.main.url(forResource: "GabrielPlayingSong", withExtension: "mp3") else {
            print("Audio file GabrielPlayingSong.mp3 not found in bundle.")
            return
        }
        do {
            let player = try AVAudioPlayer(contentsOf: url)
            player.numberOfLoops = -1 
            player.prepareToPlay()
            player.play()
            audioPlayer = player
        } catch {
            print("Failed to initialize audio player:", error)
        }
    }

    private func stopAudio() {
        audioPlayer?.stop()
        audioPlayer = nil
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                Image("houseBackgroundFinal\(backgroundFrame)")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea(edges: .all)
                GeometryReader { geometry in
                    
                    VStack(alignment: .center) {
                        Spacer()
                        
                        VStack(spacing: 16) {
                            
                            NavigationLink(destination: { PlayPianoScene() }) { Image("KeepPlayingButton").resizable().scaledToFit().frame(maxWidth: 400).accessibilityLabel("Keep Playing") }
                            NavigationLink(destination: { StartView() }) { Image("HomeButton").resizable().scaledToFit().frame(maxWidth: 400).accessibilityLabel("Home") }
                            
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
                            nextSceneBlocked: true
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
            .onAppear { startLoopingAudio() }
            .onDisappear { stopAudio() }
            .navigationDestination(isPresented: $nextScene) {
                StartView()
            }
            
        }
    }
    
}
