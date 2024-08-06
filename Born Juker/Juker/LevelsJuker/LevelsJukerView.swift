import SwiftUI

struct LevelsJukerView: View {
    
    @Environment(\.presentationMode) var p
    
    @StateObject var vm = LevelsViewModel(totalLevels: 24)
    @State private var currentPage = 0
    private let levelsPerPage = 12
    
    private var currentPageLevels: [Level] {
       let startIndex = currentPage * levelsPerPage
       let endIndex = min(startIndex + levelsPerPage, vm.levels.count)
       return Array(vm.levels[startIndex..<endIndex])
   }
   
   private var totalPages: Int {
       return (vm.levels.count + levelsPerPage - 1) / levelsPerPage
   }
    
    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    Image("left_hat")
                    Button {
                        p.wrappedValue.dismiss()
                    } label: {
                        Image("home_btn")
                    }
                    Image("right_hat")
                }
                .padding(.horizontal)
                
                Spacer()
                
                LazyVGrid(columns: [
                    GridItem(.fixed(110)),
                    GridItem(.fixed(110)),
                    GridItem(.fixed(110))
                ]) {
                    ForEach(currentPageLevels, id: \.id) { level in
                        ZStack {
                            Image("level_back")
                            if vm.isLevelAvailable(levelNumber: level.level) {
                                NavigationLink(destination: JukerGameView(level: level.level)
                                    .navigationBarBackButtonHidden(true)) {
                                        Text("\(level.level)")
                                            .font(.custom("TL-SansSerifBold", size: 42))
                                            .foregroundColor(.white)
                                    }
                            } else {
                                Image("lock")
                            }
                        }
                    }
                }
                
                Spacer()
                
                HStack {
                    Button {
                        if currentPage > 0 {
                            withAnimation {
                                currentPage -= 1
                            }
                        }
                    } label: {
                        Image("arrow_left")
                    }
                    Spacer()
                    Button {
                        if currentPage < totalPages - 1 {
                            withAnimation {
                                currentPage += 1
                            }
                        }
                    } label: {
                        Image("arrow_right")
                    }
                }
            }
            .background(JukerBack())
        }
        .onAppear {
            print(vm.levels)
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct JukerBack: View {
    var body: some View {
        Image("levels_back")
            .resizable()
            .frame(minWidth: UIScreen.main.bounds.width,
                   minHeight: UIScreen.main.bounds.height)
            .ignoresSafeArea()
    }
}

#Preview {
    LevelsJukerView()
}
