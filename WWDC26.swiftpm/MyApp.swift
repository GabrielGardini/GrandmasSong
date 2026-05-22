import SwiftUI

@main
struct MyApp: App {
    init() {
        registerFont(named: "VT323-Regular.ttf")
        UINavigationBar.setAnimationsEnabled(false)
        }
    
    var body: some Scene {
        WindowGroup {
            StartView()
        }
    }
}
