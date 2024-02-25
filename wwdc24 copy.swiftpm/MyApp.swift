import SwiftUI

@main
struct MyApp: App {
    var body: some Scene {
        WindowGroup {
            NavigationView {
                ContentView()
            }
            .accentColor(Colors.primary)
            .navigationViewStyle(.stack)
        }
    }
    
    init() {
        let fontURL = Bundle.main.url(forResource: "Poppins-Regular", withExtension: "ttf")!
        CTFontManagerRegisterFontsForURL(fontURL as CFURL, CTFontManagerScope.process, nil)
        let fontURLBold = Bundle.main.url(forResource: "Poppins-SemiBold", withExtension: "ttf")!
        CTFontManagerRegisterFontsForURL(fontURLBold as CFURL, CTFontManagerScope.process, nil)
    }
}
