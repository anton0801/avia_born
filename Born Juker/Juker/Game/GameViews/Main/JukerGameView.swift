import SwiftUI
import SpriteKit

enum Active {
    case game, win, gameOver, pause
}

struct JukerGameView: View {
    
    var level: Int
    @State var scene: JukerSceneMain!
    
    @State var callbackListener: JukerListener!
    
    @State var active: Active = .game
    
    var body: some View {
        ZStack {
            if let scene = scene {
                SpriteView(scene: scene)
                    .ignoresSafeArea()
            }
            switch (active) {
            case .win:
                JukerWinGameView()
            case .gameOver:
                JukerLoseGameView()
            case .pause:
                PauseGameView()
            default:
                EmptyView()
            }
        }
        .onAppear {
            scene = JukerSceneMain(level: level)
            self.callbackListener = JukerListener(callback: { type in
                switch (type) {
                case "win":
                    withAnimation {
                        active = .win
                    }
                case "game_over":
                    withAnimation {
                        active = .gameOver
                    }
                case "paused":
                    withAnimation {
                        active = .pause
                    }
                case "continue_game":
                    scene.isPaused = false
                    withAnimation {
                        active = .game
                    }
                case "restart_game":
                    scene = scene.restartGame()
                    withAnimation {
                        active = .game
                    }
                default:
                    withAnimation {
                        active = .game
                    }
                }
            })
        }
    }
    
}

class JukerListener {
    
    var callback: (String) -> Void
    
    init(callback: @escaping (String) -> Void) {
        self.callback = callback
        
        NotificationCenter.default.addObserver(self, selector: #selector(callbackHandle), name: Notification.Name("win"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(callbackHandle), name: Notification.Name("paused"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(callbackHandle), name: Notification.Name("game_over"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(callbackHandle), name: Notification.Name("continue_game"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(callbackHandle), name: Notification.Name("restart_game"), object: nil)
    }
    
    @objc private func callbackHandle(_ notif: Notification) {
        if notif.name == Notification.Name("win") {
            self.callback("win")
        } else if notif.name == Notification.Name("paused") {
            self.callback("paused")
        } else if notif.name == Notification.Name("game_over") {
            self.callback("game_over")
        } else if notif.name == Notification.Name("continue_game") {
            self.callback("continue_game")
        } else if notif.name == Notification.Name("restart_game") {
            self.callback("restart_game")
        }
    }
    
}

#Preview {
    JukerGameView(level: 1)
}
