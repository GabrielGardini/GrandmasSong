//
//  Chatbox.swift
//  WWDC26
//
//  Created by Gabriel Gardini on 02/02/26.
//

import SwiftUI
import AVFoundation


enum ChatCharacter: String, CaseIterable, Equatable {
    case boy
    case book
    case none

    var speakingFrames: [String] {
        switch self {
        case .boy:
            return ["boy-idle", "boy-talking1", "boy-talking2", "boy-talking1", "boy-talking2" ]
        case .book:
            return ["book-idle", "book-talking1", "book-talking2", "book-talking3"]
        case .none:
            return ["none"]
        }
    }
    
    var idleFrame: String { speakingFrames.first ?? "" }
}

struct ChatBox: View {
    let lines: [String]
    let character: ChatCharacter
    let boxSize: CGFloat
    @Binding var nextScene: Bool
    let nextSceneBlocked: Bool
    let writingAnimation: Bool
    
    let typingInterval: TimeInterval = 0.03
    let avatarFrameInterval: TimeInterval = 0.15
    
    @State private var currentLineIndex: Int = 0
    @State private var visibleText: String = ""
    @State private var isTyping: Bool = false
    @State private var avatarFrameIndex: Int = 0
    @State private var typingTimer: Timer? = nil
    @State private var avatarTimer: Timer? = nil
    @State private var isPulsing: Bool = false
    @State private var audioPlayer: AVAudioPlayer? = nil
    @State private var audioEngineEnabled: Bool = false
    @State private var lastVoiceSuffix: Int? = nil
    @State private var hasPlayedCharacterVoice: Bool = false
    
    init(
        lines: [String],
        character: ChatCharacter,
        boxSize: CGFloat,
        nextScene: Binding<Bool>,
        nextSceneBlocked: Bool,
        writingAnimation: Bool = true
    ) {
        self.lines = lines
        self.character = character
        self.boxSize = boxSize
        self._nextScene = nextScene
        self.nextSceneBlocked = nextSceneBlocked
        self.writingAnimation = writingAnimation
    }
    
    var body: some View {
        HStack(alignment: .center, spacing: 8) {
            
            Image(currentAvatarImageName)
                .resizable()
                .frame(width: boxSize, height: boxSize)
                .padding(.leading, 8)
                .padding(.bottom, character == .boy ? 26 : -10)
            
            Text(visibleText)
                .font(.custom("VT323-Regular", size: 50))
                .foregroundStyle(Color(red: 0.1176, green: 0.1098, blue: 0.1922))
                .lineLimit(3)
                .minimumScaleFactor(0.8)
                .multilineTextAlignment(.leading)
                .frame(maxWidth: character == .none ? boxSize * 6 : boxSize * 5, alignment: .leading)
                .padding(.vertical, 10)
                .padding(.trailing, 10)
                .padding(.leading, character == .none ? -100 : 0)
            
            if !nextSceneBlocked {
                Button(action: nextTapped) {
                    Image("chatbox-button")
                        .resizable()
                        .frame(width: boxSize / 4, height: boxSize / 4)
                        .scaleEffect(isPulsing ? 1.1 : 1.0)
                        .animation(.easeInOut(duration: 0.8).repeatForever(autoreverses: true), value: isPulsing)
                        .accessibilityLabel("Next")
                }
                .padding(.trailing, 50)
                .onAppear {
                    isPulsing = true
                }
                .onDisappear {
                    isPulsing = false
                }
            }
        }
        .background(
            Image(character == .boy ? "chatbox" : "chatboxBook")
                .resizable()
                .frame(height: boxSize)
        )
        .padding(.bottom, 20)
        .padding(.trailing, 20)
        .onAppear {
            hasPlayedCharacterVoice = false
            if writingAnimation {
                startTypingCurrentLine()
            } else {
                isTyping = false
                currentLineIndex = 0
                visibleText = lines[safe: currentLineIndex] ?? ""
            }
        }
        .onDisappear {
            invalidateTimers()
            hasPlayedCharacterVoice = false
        }
        
    }
    
    
    private var currentAvatarImageName: String {
        if isTyping && writingAnimation {
            let frames = character.speakingFrames
            guard !frames.isEmpty else { return "" }
            return frames[avatarFrameIndex % frames.count]
        } else {
            return character.idleFrame.isEmpty ? "" : character.idleFrame
        }
    }
        
    private func nextTapped() {
        playNextButtonSound()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
            if isTyping {
                visibleText = lines[safe: currentLineIndex] ?? ""
                stopTypingAnimation()
                return
            }
            
            let next = currentLineIndex + 1
            if next < lines.count {
                currentLineIndex = next
                if writingAnimation {
                    startTypingCurrentLine()
                } else {
                    isTyping = false
                    visibleText = lines[safe: currentLineIndex] ?? ""
                    // Character voice playback disabled
                }
            } else {
                if !nextSceneBlocked {
                    nextScene = true
                }
            }
        }
    }
    
    private func startTypingCurrentLine() {
        invalidateTimers()
        let fullText = lines[safe: currentLineIndex] ?? ""
        
        hasPlayedCharacterVoice = false
        
        guard writingAnimation else {
            visibleText = fullText
            isTyping = false
            return
        }
        
        visibleText = ""
        isTyping = true
        
        // Character voice playback disabled
        
        typingTimer = Timer.scheduledTimer(withTimeInterval: typingInterval, repeats: true) { _ in
            Task { @MainActor in
                if visibleText.count < fullText.count {
                    let nextIndex = fullText.index(fullText.startIndex, offsetBy: visibleText.count + 1)
                    visibleText = String(fullText[..<nextIndex])
                } else {
                    stopTypingAnimation()
                }
            }
        }
        
        avatarTimer = Timer.scheduledTimer(withTimeInterval: avatarFrameInterval, repeats: true) { _ in
            Task { @MainActor in
                avatarFrameIndex = (avatarFrameIndex + 1) % max(1, character.speakingFrames.count)
            }
        }
    }
    
    private func stopTypingAnimation() {
        isTyping = false
        typingTimer?.invalidate()
        typingTimer = nil
        
        avatarTimer?.invalidate()
        avatarTimer = nil
        avatarFrameIndex = 0
    }
    
    private func invalidateTimers() {
        typingTimer?.invalidate()
        typingTimer = nil
        avatarTimer?.invalidate()
        avatarTimer = nil
    }
        
    private func playCharacterVoice() {
        // Voice playback disabled as requested.
    }
    
    private func playNextButtonSound() {
        if let url = Bundle.main.url(forResource: "nextButtonSound", withExtension: "wav") {
            audioPlayer = try? AVAudioPlayer(contentsOf: url)
            audioPlayer?.volume = 0.5
            
            audioPlayer?.prepareToPlay()
            audioPlayer?.play()
            
        }
    }
}

private extension Array {
    subscript(safe index: Int) -> Element? {
        guard indices.contains(index) else { return nil }
        return self[index]
    }
}

