import AVFoundation
import SwiftUI

public enum PianoKeyState: Equatable {
    case idle
    case pressed
    case disabled
}

public struct PianoKey: View {
    @State private var audioPlayer: AVAudioPlayer?

    private let idleImageName: String
    private let pressedImageName: String
    private let disabledImageName: String
    private let keyHeight: CGFloat
    private let keyWidth: CGFloat
    private let audioFileName: String


    private let isDisabled: Bool

    private let action: () -> Void

    @State private var isPressing: Bool = false

    private func resetPressState() {
        if isPressing { isPressing = false }
    }

    public init(
        idleImageName: String,
        pressedImageName: String,
        disabledImageName: String,
        keyHeight: CGFloat,
        keyWidth: CGFloat,
        audioFileName: String,

        isDisabled: Bool = false,
        action: @escaping () -> Void
    ) {
        self.idleImageName = idleImageName
        self.pressedImageName = pressedImageName
        self.disabledImageName = disabledImageName
        self.keyHeight = keyHeight
        self.keyWidth = keyWidth
        self.audioFileName = audioFileName
        self.isDisabled = isDisabled
        self.action = action
    }

    private var currentState: PianoKeyState {
        if isDisabled { return .disabled }
        return isPressing ? .pressed : .idle
    }

    private var currentImageName: String {
        switch currentState {
        case .idle: return idleImageName
        case .pressed: return pressedImageName
        case .disabled: return disabledImageName
        }
    }

    private func playSound() {
        guard let url = Bundle.main.url(forResource: audioFileName, withExtension: "mp3") else {
            return
        }
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.prepareToPlay()
            audioPlayer?.play()
        } catch {
        }
    }

    public var body: some View {
        Image(currentImageName)
            .resizable()
            .frame(width: keyWidth, height: keyHeight)
            .accessibilityLabel(accessibilityLabel)
            .gesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { _ in
                        guard !isDisabled else { return }
                        if !isPressing {
                            isPressing = true
                            playSound()
                            action()
                        }
                    }
                    .onEnded { _ in
                        guard !isDisabled else { return }
                            resetPressState()
                    }
            )
            .onTapGesture {
                guard !isDisabled else { return }
                playSound()
                action()
            }
            .onDisappear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    resetPressState()
                }
            }
            .onChange(of: isDisabled) { newValue in
                if newValue {
                    resetPressState()
                }
            }

    }

    private var accessibilityLabel: Text {
        switch currentState {
        case .idle:     return Text("accessibility.pianoKey.idle",     bundle: .main)
        case .pressed:  return Text("accessibility.pianoKey.pressed",  bundle: .main)
        case .disabled: return Text("accessibility.pianoKey.disabled", bundle: .main)
        }
    }
}
