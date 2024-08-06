import SwiftUI
import SpriteKit

class JukerSceneMain: SKScene, SKPhysicsContactDelegate {
    
    var level: Int

    init(level: Int) {
        self.level = level
        super.init(size: CGSize(width: 750, height: 1335))
    }
    
    func restartGame() -> JukerSceneMain {
        let newScene = JukerSceneMain(level: level)
        view?.presentScene(newScene)
        return newScene
    }
    
    private var background: SKSpriteNode {
        get {
            var backgroundSource = "background_game"
            if level >= 4 && level < 8 {
                backgroundSource = "seconod_back"
            } else if level >= 8 {
                backgroundSource = "third_back"
            }
            let node = SKSpriteNode(imageNamed: backgroundSource)
            node.size = size
            node.position = CGPoint(x: size.width / 2, y: size.height / 2)
            return node
        }
    }
    
    private var controlsBtns: SKSpriteNode {
        get {
            let node = SKSpriteNode()
            
            let leftBtn = SKSpriteNode(imageNamed: "left")
            leftBtn.name = "left"
            leftBtn.size = CGSize(width: 130, height: 120)
            leftBtn.position = CGPoint(x: -(size.width / 2) + 100, y: 0)
            node.addChild(leftBtn)
            
            let pauseBtn = SKSpriteNode(imageNamed: "pause_btn")
            pauseBtn.name = "pause"
            pauseBtn.size = CGSize(width: 160, height: 130)
            node.addChild(pauseBtn)
            
            let rightBtn = SKSpriteNode(imageNamed: "right")
            rightBtn.name = "right"
            rightBtn.size = CGSize(width: 130, height: 120)
            rightBtn.position = CGPoint(x: size.width / 2 - 100, y: 0)
            node.addChild(rightBtn)
            
            node.position = CGPoint(x: size.width / 2, y: 250)
            
            return node
        }
    }
    
    private var controlsBtnsSecond: SKSpriteNode {
        get {
            let node = SKSpriteNode()
            
            let leftBtn = SKSpriteNode(imageNamed: "top")
            leftBtn.name = "top"
            leftBtn.size = CGSize(width: 130, height: 120)
            leftBtn.position = CGPoint(x: -(size.width / 2) + 100, y: 0)
            node.addChild(leftBtn)
            
            let pauseBtn = SKSpriteNode(imageNamed: "pause_btn")
            pauseBtn.name = "pause"
            pauseBtn.size = CGSize(width: 160, height: 130)
            node.addChild(pauseBtn)
            
            let rightBtn = SKSpriteNode(imageNamed: "bottom")
            rightBtn.name = "bottom"
            rightBtn.size = CGSize(width: 130, height: 120)
            rightBtn.position = CGPoint(x: size.width / 2 - 100, y: 0)
            node.addChild(rightBtn)
            
            node.position = CGPoint(x: size.width / 2, y: 250)
            
            return node
        }
    }
    
    private var levelLabel: SKSpriteNode {
        get {
            let node = SKSpriteNode()
            let levelBg = SKSpriteNode(imageNamed: "level_label_bg")
            levelBg.size = CGSize(width: 400, height: 150)
            node.addChild(levelBg)
            
            let levelLabel = SKLabelNode(text: "LEVEL \(level)")
            levelLabel.fontName = "TL-SansSerifBold"
            levelLabel.fontSize = 65
            levelLabel.fontColor = .white
            levelLabel.position = CGPoint(x: 0, y: -20)
            node.addChild(levelLabel)
            
            node.position = CGPoint(x: size.width / 2, y: 100)
            
            return node
        }
    }
    
    private var credits = UserDefaults.standard.integer(forKey: "credits") {
        didSet {
            UserDefaults.standard.set(credits, forKey: "credits")
        }
    }
    private var creditsLabel: SKLabelNode = SKLabelNode(text: "0")
    
    private var time = 30 {
        didSet {
            timeLabel.text = "TIME: \(time)"
        }
    }
    
    private var alertsTimer: Timer!
    private var obstaclesTimer: Timer!
    private var timeCounter: Timer!
    
    private var timeLabel: SKLabelNode = SKLabelNode(text: "TIME: 30")
    
    private var plane: SKSpriteNode = SKSpriteNode(imageNamed: "plane")
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMove(to view: SKView) {
        physicsWorld.contactDelegate = self
        
        addChild(background)
        
        setUpPlane()
        addChild(plane)
        
        addChild(levelLabel)
        
        let creditsLabelBg = SKSpriteNode(imageNamed: "level_label_bg")
        creditsLabelBg.size = CGSize(width: 350, height: 120)
        creditsLabelBg.position = CGPoint(x: size.width / 2, y: size.height - 150)
        addChild(creditsLabelBg)
        
        creditsLabel = .init(text: "\(credits)")
        creditsLabel.fontName = "TL-SansSerifBold"
        creditsLabel.fontSize = 54
        creditsLabel.fontColor = .white
        creditsLabel.position = CGPoint(x: size.width / 2 - 30, y: size.height - 170)
        addChild(creditsLabel)
        
        let creditIcon = SKSpriteNode(imageNamed: "credit")
        creditIcon.size = CGSize(width: 50, height: 45)
        creditIcon.position = CGPoint(x: size.width / 2 + 70, y: size.height - 150)
        addChild(creditIcon)
        
        let timeLabelBg = SKSpriteNode(imageNamed: "level_label_bg")
        timeLabelBg.size = CGSize(width: 250, height: 90)
        timeLabelBg.position = CGPoint(x: size.width / 2, y: size.height - 270)
        addChild(timeLabelBg)
        
        self.time = 30 + (self.level / 5 * 10)
        timeLabel = .init(text: "TIME: \(self.time)")
        timeLabel.fontName = "TL-SansSerifBold"
        timeLabel.fontSize = 36
        timeLabel.fontColor = .white
        timeLabel.position = CGPoint(x: size.width / 2, y: size.height - 280)
        addChild(timeLabel)
        
        if level < 5 {
            addChild(controlsBtns)
            alertsTimer = .scheduledTimer(withTimeInterval: 2.5, repeats: true, block: { _ in
                if !self.isPaused {
                    self.createAlert()
                }
            })
        } else if level >= 5 && level < 9 {
            addChild(controlsBtnsSecond)
            obstaclesTimer = .scheduledTimer(withTimeInterval: 3.5, repeats: true, block: { _ in
                if !self.isPaused {
                    self.createObstacle()
                }
            })
        }
//        else if level >= 8 {
//        }
        
        timeCounter = .scheduledTimer(withTimeInterval: 1, repeats: true, block: { _ in
            if !self.isPaused {
                self.time -= 1
                if self.time == 30 + (self.level / 5 * 10) {
                    NotificationCenter.default.post(name: Notification.Name("win"), object: nil)
                }
            }
        })
    }
    
    private var prevSpeed = 5.0
    
    private var obstacles: [SKNode] = []
    
    private func createObstacle() {
        let obstacle = ["cloud", "star"].randomElement() ?? "cloud"
        let node = SKSpriteNode(imageNamed: obstacle)
        node.size = CGSize(width: node.size.width * 1.9, height: node.size.height * 1.7)
        if obstacle == "cloud" {
            node.name = "cloud_\(UUID().uuidString)"
            node.position = CGPoint(x: size.width / 2, y: -100)
            node.zPosition = 1
            
            addChild(node)
            
            let actionMove = SKAction.move(to: CGPoint(x: node.position.x, y: size.height + 100), duration: prevSpeed)
            let actionRemove = SKAction.removeFromParent()
            let seq = SKAction.sequence([actionMove, actionRemove])
            node.run(seq) {
                self.obstacles.removeAll(where: { $0.name == node.name })
            }
        } else {
            node.name = "star_\(UUID().uuidString)"
            node.position = CGPoint(x: size.width / 2, y: size.height + 100)
            node.zPosition = 2
            
            addChild(node)
            
            let actionMove = SKAction.move(to: CGPoint(x: node.position.x, y: -100), duration: prevSpeed)
            let actionRemove = SKAction.removeFromParent()
            let seq = SKAction.sequence([actionMove, actionRemove])
            node.run(seq) {
                self.obstacles.removeAll(where: { $0.name == node.name })
            }
        }
        obstacles.append(node)
        
        prevSpeed -= 0.1
    }
    
    private func createAlert() {
        let alertType = ["alert_green", "alert_black"].randomElement() ?? "alert_green"
        let alertNode = SKSpriteNode(imageNamed: alertType)
        let spawnedX = CGFloat.random(in: 100...(size.width - 100))
        alertNode.position = CGPoint(x: spawnedX, y: size.height - 400)
        addChild(alertNode)
        
        let alertAction1 = SKAction.fadeOut(withDuration: 0.2)
        let alertAction2 = SKAction.fadeIn(withDuration: 0.2)
        let alertAction3 = SKAction.fadeOut(withDuration: 0.2)
        let alertAction4 = SKAction.fadeIn(withDuration: 0.2)
        let alertAction5 = SKAction.fadeOut(withDuration: 0.1)
        let alertAction6 = SKAction.fadeIn(withDuration: 0.1)
        let alertAction7 = SKAction.fadeOut(withDuration: 0.1)
        let alertAction8 = SKAction.removeFromParent()
        let seq = SKAction.sequence([alertAction1, alertAction2, alertAction3, alertAction4, alertAction5, alertAction6, alertAction7, alertAction8])
        alertNode.run(seq) {
            self.spawnRocket(x: spawnedX, type: alertType)
        }
    }
    
    private func spawnRocket(x: CGFloat, type: String) {
        var rocketSrc = "rocket_small"
        if type == "alert_black" {
            rocketSrc = "rocket_big"
        }
        let node = SKSpriteNode(imageNamed: rocketSrc)
        node.position = CGPoint(x: x, y: size.height - 400)
        node.size = CGSize(width: node.size.width * 1.2, height: node.size.height * 1.2)
        node.physicsBody = SKPhysicsBody(rectangleOf: node.size)
        node.physicsBody?.isDynamic = true
        node.physicsBody?.affectedByGravity = false
        node.physicsBody?.categoryBitMask = 2
        node.physicsBody?.collisionBitMask = 1
        node.physicsBody?.contactTestBitMask = 1
        node.name = rocketSrc
        addChild(node)
        
        let moveRocket = SKAction.move(to: CGPoint(x: x, y: -200), duration: prevSpeed)
        node.run(moveRocket)
        
        prevSpeed -= 0.1
    }
    
    private func setUpPlane() {
        plane.position = CGPoint(x: size.width / 2, y: 450)
        plane.size = CGSize(width: 180, height: 140)
        plane.physicsBody = SKPhysicsBody(rectangleOf: plane.size)
        plane.physicsBody?.isDynamic = false
        plane.physicsBody?.affectedByGravity = false
        plane.physicsBody?.categoryBitMask = 1
        plane.physicsBody?.contactTestBitMask = 2
        plane.physicsBody?.collisionBitMask = 2
        plane.name = "plane"
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        if let touch = touch {
            let location = touch.location(in: self)
            let objectTouched = atPoint(location)
            if objectTouched.name == "left" {
                if plane.position.x - 40 > 0 {
                    plane.run(SKAction.move(to: CGPoint(x: plane.position.x - 40, y: plane.position.y), duration: 0.2))
                }
            }
            if objectTouched.name == "right" {
                if plane.position.x + 40 < size.width {
                    plane.run(SKAction.move(to: CGPoint(x: plane.position.x + 40, y: plane.position.y), duration: 0.2))
                }
            }
            
            if objectTouched.name == "bottom" {
                if plane.zPosition > 0 {
                    let action = SKAction.resize(toWidth: plane.size.width - 40, duration: 0.4)
                    let action2 = SKAction.resize(toHeight: plane.size.height - 40, duration: 0.4)
                    let group = SKAction.group([action, action2])
                    plane.zPosition -= 1
                    plane.run(group)
                }
            }
            
            if objectTouched.name == "top" {
                let action = SKAction.resize(toWidth: plane.size.width + 40, duration: 0.4)
                let action2 = SKAction.resize(toHeight: plane.size.height + 40, duration: 0.4)
                let group = SKAction.group([action, action2])
                plane.zPosition += 1
                plane.run(group)
            }
            
            if objectTouched.name == "pause" {
                isPaused = true
                NotificationCenter.default.post(name: Notification.Name("paused"), object: nil)
            }
        }
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        let contactA = contact.bodyA
        let contactB = contact.bodyB
        
        if (contactA.categoryBitMask == 1 && contactB.categoryBitMask == 2) ||
            (contactA.categoryBitMask == 2 && contactB.categoryBitMask == 1) {
            isPaused = true
            NotificationCenter.default.post(name: Notification.Name("game_over"), object: nil)
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        if level >= 5 {
            for obstacle in obstacles {
                if obstacle.intersects(plane) {
                    let name = obstacle.name
                    if let name = name {
                        if name.contains("star") {
                            if plane.zPosition > obstacle.zPosition {
                                isPaused = true
                                NotificationCenter.default.post(name: Notification.Name("game_over"), object: nil)
                            }
                        } else {
                            if plane.zPosition < obstacle.zPosition {
                                isPaused = true
                                NotificationCenter.default.post(name: Notification.Name("game_over"), object: nil)
                            }
                        }
                    }
                }
            }
        }
    }
    
}

#Preview {
    VStack {
        SpriteView(scene: JukerSceneMain(level: 5))
            .ignoresSafeArea()
    }
}
