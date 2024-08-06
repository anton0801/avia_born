import Foundation

struct Level: Identifiable, Codable {
    var id: Int
    var level: Int
    var unlocked: Bool
    
    init(id: Int, level: Int, unlocked: Bool = false) {
        self.id = id
        self.level = level
        self.unlocked = unlocked
    }
}
