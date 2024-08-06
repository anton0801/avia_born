import SwiftUI

struct PauseGameView: View {
    var body: some View {
        VStack {
            ZStack {
                Image("title_bg")
                Text("PAUSED")
                    .font(.custom("TL-SansSerifBold", size: 38))
                    .foregroundColor(.white)
            }
            
            Spacer()
            
            ZStack {
                Image("content_bg")
                Text("The game is paused")
                    .font(.custom("TL-SansSerifBold", size: 26))
                    .foregroundColor(.white)
                    .frame(width: 300)
                    .multilineTextAlignment(.center)
            }
            
            HStack {
                Button {
                    NotificationCenter.default.post(name: Notification.Name("restart_game"), object: nil)
                } label: {
                    Image("restart")
                }
                Button {
                    NotificationCenter.default.post(name: Notification.Name("continue_game"), object: nil)
                } label: {
                    Image("play_btn_next")
                }
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
}

#Preview {
    PauseGameView()
}
