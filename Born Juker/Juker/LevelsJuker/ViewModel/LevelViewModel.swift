import Foundation


class LevelsViewModel: ObservableObject {
    @Published var levels: [Level] = []
    private let userDefaultsKey = "levelsData"

    init(totalLevels: Int = 24) {
         loadLevels(totalLevels: totalLevels)
     }
    
    func updateUnlockStatus(currentLevel: Int) {
        for i in 0..<levels.count {
            if levels[i].level <= currentLevel {
                levels[i].unlocked = true
            }
        }
        saveLevels()
    }
    
    func isLevelAvailable(levelNumber: Int) -> Bool {
        guard levelNumber > 0 && levelNumber <= levels.count else {
            return false
        }
        return levels[levelNumber - 1].unlocked
    }
    
    private func loadLevels(totalLevels: Int) {
        if let savedLevelsData = UserDefaults.standard.data(forKey: userDefaultsKey) {
            if let decodedLevels = try? JSONDecoder().decode([Level].self, from: savedLevelsData) {
                self.levels = decodedLevels
                return
            }
        }
        // Initialize levels if no data found
        for i in 1...totalLevels {
            let level = Level(id: i, level: i, unlocked: i == 1) // Unlocking only the first level initially
            levels.append(level)
        }
        saveLevels() // Save initial state
    }
    
    private func saveLevels() {
        if let encodedLevels = try? JSONEncoder().encode(levels) {
            UserDefaults.standard.set(encodedLevels, forKey: userDefaultsKey)
        }
    }
    
}
