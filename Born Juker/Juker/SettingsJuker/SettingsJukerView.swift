import SwiftUI

struct SettingsJukerView: View {
    
    @Environment(\.presentationMode) var pr
    @State var volumeApp = UserDefaults.standard.bool(forKey: "volume_app")
    @State var soundsApp = UserDefaults.standard.bool(forKey: "sounds_app")
    
    var body: some View {
        VStack {
            ZStack {
                Image("title_bg")
                Text("SETTINGS")
                    .font(.custom("TL-SansSerifBold", size: 24))
                    .foregroundColor(.white)
            }
            
            ZStack {
                Image("settings_items_bg")
                VStack {
                    HStack {
                        Button {
                            withAnimation {
                                volumeApp = !volumeApp
                            }
                        } label: {
                            Image("volume_app")
                            if volumeApp {
                                Image("sounds_on")
                            } else {
                                Image("sounds_off")
                            }
                        }
                    }
                    HStack {
                        Button {
                            withAnimation {
                                soundsApp = !soundsApp
                            }
                        } label: {
                            Image("sounds_app")
                            if soundsApp {
                                Image("sounds_on")
                            } else {
                                Image("sounds_off")
                            }
                        }
                    }
                }
            }
            Button {
                UserDefaults.standard.set(volumeApp, forKey: "volume_app")
                UserDefaults.standard.set(soundsApp, forKey: "sounds_app")
                pr.wrappedValue.dismiss()
            } label: {
                Image("done_btn")
            }
            .offset(y: -20)
            
        }
        .background(
            BackgroundImageMain()
        )
    }
}

#Preview {
    SettingsJukerView()
}
