//: A SpriteKit based Playground

import PlaygroundSupport
import SpriteKit

class GameScene: SKScene {
    
    private var plane : SKShapeNode!
    private var wall :SKShapeNode!
    private var distance = 0
    private var inGame = true
    private var gameOverLabel : SKLabelNode!
    private var label :SKLabelNode!
    
    override func didMove(to view: SKView) {
        // Remove HelloLabel
        label = childNode(withName: "//helloLabel") as? SKLabelNode
        label.removeFromParent()
        
        // Create a Plane
        var points = [CGPoint(x: -45, y: -25),
                      CGPoint(x:  45, y: -25),
                      CGPoint(x: -15, y:  25),
                      CGPoint(x: -45, y: -25)]
        plane = SKShapeNode(points: &points, count: points.count)
        plane.fillColor = SKColor.white
        plane.position = CGPoint(
            x: self.frame.midX - self.frame.size.width / 6.0,
            y: self.frame.midY - 100
        )
        plane.physicsBody = SKPhysicsBody(circleOfRadius: 45)
        plane.physicsBody?.velocity = CGVector(dx: 0.0, dy: 200.0)
        plane.physicsBody?.applyImpulse(CGVector(dx: 0.0, dy: 200.0))
        
        addChild(plane)
        
        // Create Wall
        wall = SKShapeNode(rectOf: CGSize(
            width: size.width / 20.0,
            height: size.height
        ))
        wall.fillColor = SKColor.brown
        let goAndRemove = SKAction.sequence([
            .move(
                by: CGVector(dx: -self.frame.size.width, dy: 0.0),
                duration: 5.0
            ),
            .removeFromParent()
            ])
        wall.run(.repeatForever(goAndRemove))
        wall.physicsBody = SKPhysicsBody(rectangleOf: CGSize(
            width: size.width / 20.0,
            height: size.height
        ))
        wall.physicsBody?.affectedByGravity = false
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        plane.physicsBody?.velocity = CGVector(dx: 0.0, dy: 0.0)
        plane.physicsBody?.applyImpulse(CGVector(dx: 0.0, dy: 100.0))
    }
 
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        if !inGame {
            return
        }
        if plane.position.x < self.frame.midX - self.frame.size.width / 2.0 || plane.position.y < self.frame.midY - self.frame.size.height / 2.0 {
            inGame = false
            gameOverLabel = SKLabelNode(text: "SCORE \(distance)")
            gameOverLabel.fontSize = 70
            addChild(gameOverLabel)
        }
        
        if distance % 70 == 0 {
            let wall_clone = wall.copy() as! SKShapeNode
            var wallYPosition = self.frame.midY
            if arc4random_uniform(2) >= 1 {
                wallYPosition += self.frame.size.height * (0.4 + CGFloat(arc4random_uniform(51)) / 100.0)
            } else {
                wallYPosition -= self.frame.size.height * (0.4 + CGFloat(arc4random_uniform(51)) / 100.0)
            }
            wall_clone.position = CGPoint(
                x: self.frame.midX + self.frame.size.width / 2.0,
                y: wallYPosition
            )
            addChild(wall_clone)
        }
        distance += 1
    }
}

// Load the SKScene from 'GameScene.sks'
let sceneView = SKView(frame: CGRect(x:0 , y:0, width: 640, height: 480))
if let scene = GameScene(fileNamed: "GameScene") {
    // Set the scale mode to scale to fit the window
    scene.scaleMode = .aspectFill
    
    scene.backgroundColor = UIColor(
        red:   0,
        green: 175 / 255,
        blue:  219 / 255,
        alpha: 1.0
    )
    scene.physicsWorld.gravity = CGVector(dx: 0.0, dy: -2.0)
    
    // Present the scene
    sceneView.presentScene(scene)
}

PlaygroundSupport.PlaygroundPage.current.liveView = sceneView
