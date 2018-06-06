//: A SpriteKit based Playground

import PlaygroundSupport
import SpriteKit

class GameScene: SKScene {
    
    private var label :SKLabelNode!
    private var wall :SKShapeNode!
    private var plane : SKShapeNode!
    private var gameOverLabel : SKLabelNode!
    
    private var distance = 0
    private var inGame = true
    
    override func didMove(to view: SKView) {
        // Remove HelloLabel
        label = childNode(withName: "//helloLabel") as? SKLabelNode
        label.removeFromParent()
        
        // Create Plane
        let w = (size.width + size.height) * 0.05

        var points = [CGPoint(x: -w / 2.0, y: -w / 4.0),
                      CGPoint(x:  w / 2.0, y: -w / 4.0),
                      CGPoint(x: -w / 6.0, y:  w / 4.0),
                      CGPoint(x: -w / 2.0, y: -w / 4.0)]
        plane = SKShapeNode(points: &points, count: points.count)
        plane.fillColor = SKColor.white
        plane.position = CGPoint(x: self.frame.midX - self.frame.size.width / 6.0, y: self.frame.midY)
        plane.physicsBody = SKPhysicsBody(circleOfRadius: max(w / 2, w / 2))
        plane.physicsBody?.velocity = CGVector(dx: 0.0, dy: 200.0)
        plane.physicsBody?.applyImpulse(CGVector(dx: 0.0, dy: 200.0))
    
        addChild(plane)
        
        // Create Wall
        wall = SKShapeNode(rectOf: CGSize(width: size.width / 20.0, height: size.height))
        wall.fillColor = SKColor.brown
        let goAndRemove = SKAction.sequence([.move(by: CGVector(dx: -self.frame.size.width, dy: 0.0), duration: 5.0),
                                             .removeFromParent()])
        wall.run(.repeatForever(goAndRemove))
        wall.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: size.width / 20.0,
                                                                             height: size.height))
        wall.physicsBody?.affectedByGravity = false
    }
    
    func touchUp(atPoint pos : CGPoint) {
        plane.physicsBody?.velocity = CGVector(dx: 0.0, dy: 0.0)
        plane.physicsBody?.applyImpulse(CGVector(dx: 0.0, dy: 100.0))
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { touchUp(atPoint: t.location(in: self)) }
    }

    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { touchUp(atPoint: t.location(in: self)) }
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        if !inGame {
            return
        }
        if plane.position.x < self.frame.midX - self.frame.size.width / 3.2 || plane.position.y < self.frame.midY - self.frame.size.height / 2.0 {
            inGame = false
            gameOverLabel = SKLabelNode(text: "SCORE \(distance)")
            gameOverLabel.fontSize = 70
            addChild(gameOverLabel)
        }
        
        if distance % 70 == 0 {
            let wall_clone = wall.copy() as! SKShapeNode
            var wallYPosition = self.frame.midY - self.frame.size.height * (0.25 + CGFloat(arc4random_uniform(51)) / 100.0)
            if arc4random_uniform(2) >= 1 {
                wallYPosition += self.frame.size.height * 1.25
            }
            wall_clone.position = CGPoint(x: self.frame.midX + self.frame.size.width / 2.0, y: wallYPosition)
            addChild(wall_clone)
        }
        distance += 1
    }
}

// Load the SKScene from 'GameScene.sks'
let sceneView = SKView(frame: CGRect(x:0 , y:0, width: 480, height: 640))
if let scene = GameScene(fileNamed: "GameScene") {
    // Set the scale mode to scale to fit the window
    scene.scaleMode = .aspectFill
    
    scene.physicsWorld.gravity = CGVector(dx: 0.0, dy: -2.0)
    
    // Present the scene
    sceneView.presentScene(scene)
}

PlaygroundSupport.PlaygroundPage.current.liveView = sceneView
