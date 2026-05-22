import SwiftUI
import AVFAudio

struct StartView: View {
    @State private var pressedKeys: [String] = []
    @State private var nextScene: Bool = false
    @State private var audioPlayer: AVAudioPlayer?
    
    @State private var keyVectors: [[Bool]] = [[true, true, true, true, true, true, true, true, true, false, true, true, true, true, true, true, true],
                                               [true, true, true, true, true, true, true, true, true, true, true, true, false, true, true, true, false]
    ]
    @State private var currentVectorIndex: Int = 0
    @State private var activeKeys: [Bool] = []
    
    @State private var bgFrameIndex: Int = 0
    @State private var bgTimer: Timer? = nil
    
    @State private var bgFrame: [String] = ["1","2","3","4","5","1","2","3","4","5","1","2","3","4","5","1","2","3","4","5", "6", "7", "8", "9", "10", "11", "12", "13", "14"]
    
    private var currentBackgroundName: String {
        "startView\(bgFrame[bgFrameIndex])"
    }
    
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
                Image(currentBackgroundName)
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea(edges: .all)
                GeometryReader { geometry in
                    VStack(alignment: .center) {
                        Spacer()
                        
                        VStack(spacing: 16) {
                            NavigationLink(destination: { IntroductionScene() }) { Image("PlayButton").resizable().scaledToFit().frame(maxWidth: 400).accessibilityLabel("Play") }
                            NavigationLink(destination: { AboutMe() }) { Image("AboutButton").resizable().scaledToFit().frame(maxWidth: 400).accessibilityLabel("About me") }
                        }
                        .padding(.horizontal)
                        .frame(maxWidth: .infinity)
                        
                        
                        Spacer()
                            .frame(height: geometry.size.height / 30)
                    }
                    .frame(maxWidth: .infinity)
                    .onAppear {
                        if activeKeys.isEmpty, let first = keyVectors.first {
                            activeKeys = first
                        }
                    }
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
                        
                        if [ "e4", "c4"].allSatisfy(newValue.contains) {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                nextScene = true
                            }
                        }
                    }
                }
                .navigationBarBackButtonHidden(true)
                
                
            }
            .onAppear {
                startLoopingAudio()
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
                stopAudio()
            }
            .navigationDestination(isPresented: $nextScene) {
                BookPlaysAmScene2()
            }
            
        }
    }
    
}

#Preview {
    StartView()
}

