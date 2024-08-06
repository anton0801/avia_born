import SwiftUI

struct JukerWinGameView: View {
    
    @Environment(\.presentationMode) var pr
    
    var body: some View {
        NavigationView {
            VStack {
                NavigationLink(destination: SettingsJukerView()) {
                    Image("settings_btn_state")
                }
                
                ZStack {
                    Image("title_bg")
                    Text("WIN")
                        .font(.custom("TL-SansSerifBold", size: 42))
                        .foregroundColor(.white)
                }
                
                Spacer()
                
                ZStack {
                    Image("content_bg")
                    Text("Great work! You completed the level and earned 10 coins")
                        .font(.custom("TL-SansSerifBold", size: 22))
                        .foregroundColor(.white)
                        .frame(width: 250)
                        .multilineTextAlignment(.center)
                }
                
                Button {
                    pr.wrappedValue.dismiss()
                } label: {
                    Image("play_btn_next")
                }
                .offset(y: -20)
                
                Spacer()
            }
            .background(
                Image("game_stat_view")
                    .resizable()
                    .frame(minWidth: UIScreen.main.bounds.width,
                           minHeight: UIScreen.main.bounds.height)
                    .ignoresSafeArea()
            )
            .onAppear {
                UserDefaults.standard.set(UserDefaults.standard.integer(forKey: "credits") + 10, forKey: "credits")
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

#Preview {
    JukerWinGameView()
}
