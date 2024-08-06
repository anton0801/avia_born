import SwiftUI

struct JukerLoseGameView: View {

    @Environment(\.presentationMode) var pr
    
    var body: some View {
        NavigationView {
            VStack {
                NavigationLink(destination: SettingsJukerView()) {
                    Image("settings_btn_state")
                }
                
                ZStack {
                    Image("title_bg")
                    Text("LOSE")
                        .font(.custom("TL-SansSerifBold", size: 42))
                        .foregroundColor(.white)
                }
                
                Spacer()
                
                ZStack {
                    Image("content_bg")
                    Text("Your effort wasn't successful, but try again")
                        .font(.custom("TL-SansSerifBold", size: 22))
                        .foregroundColor(.white)
                        .frame(width: 250)
                        .multilineTextAlignment(.center)
                }
                
                Button {
                    NotificationCenter.default.post(name: Notification.Name("restart_game"), object: nil)
                } label: {
                    Image("restart")
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
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
    
}

#Preview {
    JukerLoseGameView()
}
