import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    Button {
                        exitApp()
                    } label: {
                        Image("exit_btn")
                    }
                    Spacer()
                    NavigationLink(destination: SettingsJukerView()
                        .navigationBarBackButtonHidden(true)) {
                            Image("settings_btn")
                    }
                }
                Spacer()
                NavigationLink(destination: LevelsJukerView()
                    .navigationBarBackButtonHidden(true)) {
                    Image("play_btn")
                }
                    .offset(y: -10)
                Spacer()
            }
            .background(
                BackgroundImageMain()
            )
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
    
    private func exitApp() {
        exit(0)
    }
    
}

struct BackgroundImageMain: View {
    var body: some View {
        Image("juker_back")
            .resizable()
            .frame(minWidth: UIScreen.main.bounds.width,
                   minHeight: UIScreen.main.bounds.height)
            .ignoresSafeArea()
    }
}

#Preview {
    ContentView()
}
