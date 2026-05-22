import SwiftUI

struct PianoView: View {
    let width: CGFloat
    let height: CGFloat
    @Binding var pressedKeys: [String]
    let disabledKeys: [Bool]
    
    private func isDisabled(_ index: Int) -> Bool {
        guard index >= 0 && index < disabledKeys.count else { return false }
        return disabledKeys[index]
    }
    
    var body: some View {
        
        HStack( spacing: 0){
            Rectangle()
                .fill(
                    LinearGradient(
                        colors: [Color.black.opacity(0.5), Color(red: 250/255, green: 241/255, blue: 223/255)],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .frame(width: width / 12 , height: height / 3)
                .overlay(
                    Rectangle()
                        .stroke(Color(red: 30/255, green: 28/255, blue: 49/255), lineWidth: 5)
                )
            
            
            HStack(alignment: .top, spacing: 0) {
                PianoKey(
                    idleImageName: "c3",
                    pressedImageName: "c3Pressed",
                    disabledImageName: "firstKeyDisabled",
                    keyHeight: height / 3,
                    keyWidth: width / 12,
                    audioFileName: "c3",
                    isDisabled: isDisabled(0)
                ) {
                    
                    pressedKeys.append("c3")
                }
                
                PianoKey(
                    idleImageName: "d3",
                    pressedImageName: "d3Pressed",
                    disabledImageName: "rightKeyDisabled",
                    keyHeight: height / 3,
                    keyWidth: width / 12,
                    audioFileName: "d3",
                    isDisabled: isDisabled(2)
                ) { pressedKeys.append("d3") }
                
                PianoKey(
                    idleImageName: "e",
                    pressedImageName: "ePressed",
                    disabledImageName: "rightKeyDisabled",
                    keyHeight: height / 3,
                    keyWidth: width / 12,
                    audioFileName: "e3",
                    isDisabled: isDisabled(4)
                ) { pressedKeys.append("e3") }
            }
            .overlay(alignment: .top) {
                HStack(spacing: width / 27) {
                    PianoKey(
                        idleImageName: "blackDefault",
                        pressedImageName: "blackPressed",
                        disabledImageName: "blackDisabled",
                        keyHeight: height * (2 / 9),
                        keyWidth: width * (10/192),
                        audioFileName: "c3#",
                        isDisabled: isDisabled(1)
                    ) { pressedKeys.append("c3#") }
                    
                    PianoKey(
                        idleImageName: "blackDefault",
                        pressedImageName: "blackPressed",
                        disabledImageName: "blackDisabled",
                        keyHeight: height * (2 / 9),
                        keyWidth: width * (10/192),
                        audioFileName: "d3#",
                        isDisabled: isDisabled(3)
                    ) { pressedKeys.append("d3#") }
                }
            }
            
            HStack(alignment: .top, spacing: 0) {
                PianoKey(
                    idleImageName: "f",
                    pressedImageName: "fPressed",
                    disabledImageName: "rightKeyDisabled",
                    keyHeight: height / 3,
                    keyWidth: width / 12,
                    audioFileName: "f3",
                    isDisabled: isDisabled(5)
                ) { pressedKeys.append("f3") }
                
                PianoKey(
                    idleImageName: "g",
                    pressedImageName: "gPressed",
                    disabledImageName: "rightKeyDisabled",
                    keyHeight: height / 3,
                    keyWidth: width / 12,
                    audioFileName: "g3",
                    isDisabled: isDisabled(7)
                ) { pressedKeys.append("g3") }
                
                PianoKey(
                    idleImageName: "a",
                    pressedImageName: "aPressed",
                    disabledImageName: "rightKeyDisabled",
                    keyHeight: height / 3,
                    keyWidth: width / 12,
                    audioFileName: "a4",
                    isDisabled: isDisabled(9)
                ) { pressedKeys.append("a4") }
                
                PianoKey(
                    idleImageName: "b",
                    pressedImageName: "bPressed",
                    disabledImageName: "rightKeyDisabled",
                    keyHeight: height / 3,
                    keyWidth: width / 12,
                    audioFileName: "b4",
                    isDisabled: isDisabled(11)
                ) { pressedKeys.append("b4") }
            }
            .overlay(alignment: .top) {
                HStack(spacing: width / 27) {
                    PianoKey(
                        idleImageName: "blackDefault",
                        pressedImageName: "blackPressed",
                        disabledImageName: "blackDisabled",
                        keyHeight: height * (2 / 9),
                        keyWidth: width * (10/192),
                        audioFileName: "f3#",
                        isDisabled: isDisabled(6)
                    ) { pressedKeys.append("f3#") }
                    
                    PianoKey(
                        idleImageName: "blackDefault",
                        pressedImageName: "blackPressed",
                        disabledImageName: "blackDisabled",
                        keyHeight: height * (2 / 9),
                        keyWidth: width * (10/192),
                        audioFileName: "g3#",
                        isDisabled: isDisabled(8)
                    ) { pressedKeys.append("g3#") }
                    
                    PianoKey(
                        idleImageName: "blackDefault",
                        pressedImageName: "blackPressed",
                        disabledImageName: "blackDisabled",
                        keyHeight: height * (2 / 9),
                        keyWidth: width * (10/192),
                        audioFileName: "a4#",
                        isDisabled: isDisabled(10)
                    ) { pressedKeys.append("a4#") }
                }
            }
            
            // Third white-key group: C4, D4, E4 (3 keys)
            HStack(alignment: .top, spacing: 0) {
                PianoKey(
                    idleImageName: "c4",
                    pressedImageName: "c4Pressed",
                    disabledImageName: "rightKeyDisabled",
                    keyHeight: height / 3,
                    keyWidth: width / 12,
                    audioFileName: "c4",
                    isDisabled: isDisabled(12)
                ) { pressedKeys.append("c4") }
                
                PianoKey(
                    idleImageName: "d3",
                    pressedImageName: "d3Pressed",
                    disabledImageName: "rightKeyDisabled",
                    keyHeight: height / 3,
                    keyWidth: width / 12,
                    audioFileName: "d4",
                    isDisabled: isDisabled(14)
                ) { pressedKeys.append("d4") }
                
                PianoKey(
                    idleImageName: "e",
                    pressedImageName: "ePressed",
                    disabledImageName: "rightKeyDisabled",
                    keyHeight: height / 3,
                    keyWidth: width / 12,
                    audioFileName: "e4",
                    isDisabled: isDisabled(16)
                ) { pressedKeys.append("e4") }
            }
            .overlay(alignment: .top) {
                // Black keys over the third group: C#4, D#4 (2 keys)
                HStack(spacing: width / 27) {
                    PianoKey(
                        idleImageName: "blackDefault",
                        pressedImageName: "blackPressed",
                        disabledImageName: "blackDisabled",
                        keyHeight: height * (2 / 9),
                        keyWidth: width * (10/192),
                        audioFileName: "c4#",
                        isDisabled: isDisabled(13)
                    ) { pressedKeys.append("c4#") }
                    
                    PianoKey(
                        idleImageName: "blackDefault",
                        pressedImageName: "blackPressed",
                        disabledImageName: "blackDisabled",
                        keyHeight: height * (2 / 9),
                        keyWidth: width * (10/192),
                        audioFileName: "d4#",
                        isDisabled: isDisabled(15)
                    ) { pressedKeys.append("d4#") }
                }
            }
            
            Rectangle()
                .fill(
                    LinearGradient(
                        colors: [Color(red: 250/255, green: 241/255, blue: 223/255), Color.black.opacity(0.5)],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .frame(width: width / 12, height: height / 3)
                .overlay(
                    Rectangle()
                        .stroke(Color(red: 30/255, green: 28/255, blue: 49/255), lineWidth: 5)
                )
        }
    }
}

#Preview {
    PianoView(width: 600, height: 300, pressedKeys: .constant([]), disabledKeys: Array(repeating: false, count: 17))
}
