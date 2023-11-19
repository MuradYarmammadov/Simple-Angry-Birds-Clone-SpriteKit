//
//  GameScene.swift
//  Angry Birds Clone
//
//  Created by Murad Yarmamedov on 19.11.23.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    var bird = SKSpriteNode()
    var background = SKSpriteNode()
    var tree = SKSpriteNode()
    var brick1 = SKSpriteNode()
    var brick2 = SKSpriteNode()
    var brick3 = SKSpriteNode()
    var brick4 = SKSpriteNode()
    var brick5 = SKSpriteNode()
    var brick6 = SKSpriteNode()
    var scoreLabel = SKLabelNode()
    
    var gameStarted = false
    var originalPosition: CGPoint?
    var score = 0
    
    enum colliderType: UInt32 {
        case Bird = 1
        case Brick = 2
    }
    
    override func didMove(to view: SKView) {
        
        setUI()
        setPhysics()
    }
    
    func setUI(){
        
        self.scene?.scaleMode = .aspectFit
        self.physicsBody = SKPhysicsBody(edgeLoopFrom: frame)
        self.physicsWorld.contactDelegate = self
        
        //Background
        let backgroundTexture = SKTexture(imageNamed: "background")
        background = SKSpriteNode(texture: backgroundTexture)
        background.position = CGPoint(x: 0, y: 0)
        background.size = CGSize(width: self.frame.width, height: self.frame.height)
        background.zPosition = -1
        self.addChild(background)
        
        // Bird
        let birdTexture = SKTexture(imageNamed: "bird")
        bird = SKSpriteNode(texture: birdTexture)
        bird.position = CGPoint(x: -(self.frame.width / 3.2), y: -(self.frame.height / 7))
        bird.size = CGSize(width: self.frame.width / 11, height: self.frame.height / 7)
        bird.zPosition = 1
        bird.zRotation = 0.2
        originalPosition = bird.position
        self.addChild(bird)
        
        //Tree
        let treeTexture = SKTexture(imageNamed: "tree")
        tree = SKSpriteNode(texture: treeTexture)
        tree.position = CGPoint(x: -(self.frame.width / 3.5), y: -(self.frame.height/5))
        tree.size = CGSize(width: self.frame.width/3, height: self.frame.height/1.3)
        tree.zPosition = 0
        self.addChild(tree)
        
        //Brickes
        let brickTextures = SKTexture(imageNamed: "brick")
        
        brick1 = SKSpriteNode(texture: brickTextures)
        brick1.position = CGPoint(x: self.frame.width/5, y: -(self.frame.height/2.2))
        brick1.size = CGSize(width: self.frame.width / 14, height: self.frame.height / 8)
        brick1.zPosition = 1
        self.addChild(brick1)
        
        brick2 = SKSpriteNode(texture: brickTextures)
        brick2.position = CGPoint(x: ((self.frame.width / 5) + (self.frame.width / 14)), y: -(self.frame.height/2.2))
        brick2.size = CGSize(width: self.frame.width / 14, height: self.frame.height / 8)
        brick2.zPosition = 1
        self.addChild(brick2)

        brick3 = SKSpriteNode(texture: brickTextures)
        brick3.position = CGPoint(x: ((self.frame.width / 5) + (self.frame.width / 7)), y: -(self.frame.height/2.2))
        brick3.size = CGSize(width: self.frame.width / 14, height: self.frame.height / 8)
        brick3.zPosition = 1
        self.addChild(brick3)

        brick4 = SKSpriteNode(texture: brickTextures)
        brick4.position = CGPoint(x: (self.frame.width / 5) + (self.frame.width / 28) , y: -(self.frame.height/2.2) + (self.frame.height / 8))
        brick4.size = CGSize(width: self.frame.width / 14, height: self.frame.height / 8)
        brick4.zPosition = 1
        self.addChild(brick4)
        
        brick5 = SKSpriteNode(texture: brickTextures)
        brick5.position = CGPoint(x: (self.frame.width / 5) + 3*(self.frame.width / 28) , y: -(self.frame.height/2.2) + (self.frame.height / 8))
        brick5.size = CGSize(width: self.frame.width / 14, height: self.frame.height / 8)
        brick5.zPosition = 1
        self.addChild(brick5)
        
        brick6 = SKSpriteNode(texture: brickTextures)
        brick6.position = CGPoint(x: (self.frame.width / 5) + (self.frame.width / 14) , y: -(self.frame.height/2.2) + (self.frame.height / 4))
        brick6.size = CGSize(width: self.frame.width / 14, height: self.frame.height / 8)
        brick6.zPosition = 1
        self.addChild(brick6)
        
        //Score label
        scoreLabel.fontName = "Helvetica"
        scoreLabel.fontSize = 60
        scoreLabel.text = "0"
        scoreLabel.position = CGPoint(x: 0, y: self.frame.height / 2.5)
        scoreLabel.zPosition = 2
        self.addChild(scoreLabel)
    }
    
    func fixBricksPositions(){
        brick1.position = CGPoint(x: self.frame.width/5, y: -(self.frame.height/2.2))
        brick2.position = CGPoint(x: ((self.frame.width / 5) + (self.frame.width / 14)), y: -(self.frame.height/2.2))
        brick3.position = CGPoint(x: ((self.frame.width / 5) + (self.frame.width / 7)), y: -(self.frame.height/2.2))
        brick4.position = CGPoint(x: (self.frame.width / 5) + (self.frame.width / 28) , y: -(self.frame.height/2.2) + (self.frame.height / 8))
        brick5.position = CGPoint(x: (self.frame.width / 5) + 3*(self.frame.width / 28) , y: -(self.frame.height/2.2) + (self.frame.height / 8))
        brick6.position = CGPoint(x: (self.frame.width / 5) + (self.frame.width / 14) , y: -(self.frame.height/2.2) + (self.frame.height / 4))
    }
    
    func setPhysics() {
        
        //Bird Physics
        let birdTexture = SKTexture(imageNamed: "bird")
        bird.physicsBody = SKPhysicsBody(circleOfRadius: (birdTexture.size().height / 4) - 5)
        bird.physicsBody?.affectedByGravity = false
        bird.physicsBody?.isDynamic = true
        bird.physicsBody?.mass = 0.15
        bird.physicsBody?.contactTestBitMask = colliderType.Bird.rawValue
        bird.physicsBody?.categoryBitMask = colliderType.Bird.rawValue
        bird.physicsBody?.collisionBitMask = colliderType.Brick.rawValue
        
        //Bricks Physics
        let brickTextures = SKTexture(imageNamed: "brick")
        let brickSize = CGSize(width: brickTextures.size().width/2, height: (birdTexture.size().height/2) - 10)
        
        brick1.physicsBody = SKPhysicsBody(rectangleOf: brickSize)
        brick1.physicsBody?.isDynamic = true
        brick1.physicsBody?.affectedByGravity = true
        brick1.physicsBody?.allowsRotation = true
        brick1.physicsBody?.mass = 0.1
        brick1.physicsBody?.collisionBitMask = colliderType.Bird.rawValue
        
        brick2.physicsBody = SKPhysicsBody(rectangleOf: brickSize)
        brick2.physicsBody?.isDynamic = true
        brick2.physicsBody?.affectedByGravity = true
        brick2.physicsBody?.allowsRotation = true
        brick2.physicsBody?.mass = 0.1
        brick2.physicsBody?.collisionBitMask = colliderType.Bird.rawValue

        brick3.physicsBody = SKPhysicsBody(rectangleOf: brickSize)
        brick3.physicsBody?.isDynamic = true
        brick3.physicsBody?.affectedByGravity = true
        brick3.physicsBody?.allowsRotation = true
        brick3.physicsBody?.mass = 0.1
        brick3.physicsBody?.collisionBitMask = colliderType.Bird.rawValue

        brick4.physicsBody = SKPhysicsBody(rectangleOf: brickSize)
        brick4.physicsBody?.isDynamic = true
        brick4.physicsBody?.affectedByGravity = true
        brick4.physicsBody?.allowsRotation = true
        brick4.physicsBody?.mass = 0.1
        brick4.physicsBody?.collisionBitMask = colliderType.Bird.rawValue

        brick5.physicsBody = SKPhysicsBody(rectangleOf: brickSize)
        brick5.physicsBody?.isDynamic = true
        brick5.physicsBody?.affectedByGravity = true
        brick5.physicsBody?.allowsRotation = true
        brick5.physicsBody?.mass = 0.1
        brick5.physicsBody?.collisionBitMask = colliderType.Bird.rawValue

        brick6.physicsBody = SKPhysicsBody(rectangleOf: brickSize)
        brick6.physicsBody?.isDynamic = true
        brick6.physicsBody?.affectedByGravity = true
        brick6.physicsBody?.allowsRotation = true
        brick6.physicsBody?.mass = 0.1
        brick6.physicsBody?.collisionBitMask = colliderType.Bird.rawValue
    }
    
    func touchDown(atPoint pos : CGPoint) {
        
    }
    
    func touchMoved(toPoint pos : CGPoint) {
        
    }
    
    func touchUp(atPoint pos : CGPoint) {
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if gameStarted == false {
            if let touch = touches.first {
                let touchLocation = touch.location(in: self)
                let touchNodes = nodes(at: touchLocation)
                
                if touchNodes.isEmpty == false {
                    for node in touchNodes {
                        if let sprite = node as? SKSpriteNode {
                            if sprite == bird {
                                bird.position = touchLocation
                            }
                        }
                    }
                }
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if gameStarted == false {
            if let touch = touches.first {
                let touchLocation = touch.location(in: self)
                let touchNodes = nodes(at: touchLocation)
                
                if touchNodes.isEmpty == false {
                    for node in touchNodes {
                        if let sprite = node as? SKSpriteNode {
                            if sprite == bird {
                                bird.position = touchLocation
                            }
                        }
                    }
                }
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if gameStarted == false {
            if let touch = touches.first {
                let touchLocation = touch.location(in: self)
                let touchNodes = nodes(at: touchLocation)
                
                if touchNodes.isEmpty == false {
                    for node in touchNodes {
                        if let sprite = node as? SKSpriteNode {
                            if sprite == bird {
                                if let originalPosition = originalPosition {
                                    let dx = -(touchLocation.x - originalPosition.x)
                                    let dy = -(touchLocation.y - originalPosition.y)
                                    
                                    let impulse = CGVector(dx: dx, dy: dy)
                                    bird.physicsBody?.applyImpulse(impulse)
                                    bird.physicsBody?.affectedByGravity = true
                                    gameStarted = true
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        if let birdPhysicsBody = bird.physicsBody {
            if birdPhysicsBody.velocity.dx <= 0.4 &&
                birdPhysicsBody.velocity.dy <= 0.4 &&
                birdPhysicsBody.angularVelocity <= 0.4 &&
                gameStarted == true {
                bird.physicsBody?.affectedByGravity = false
                bird.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
                bird.physicsBody?.angularVelocity = 0
                bird.zPosition = 1
                bird.zRotation = 0.2
                score = 0
                scoreLabel.text = String(score)
                fixBricksPositions()
                if let originalPosition = originalPosition {
                    bird.position = originalPosition
                }
                gameStarted = false
            }
        }
    }
}

extension GameScene: SKPhysicsContactDelegate {
    func didBegin(_ contact: SKPhysicsContact) {
        if contact.bodyA.collisionBitMask == colliderType.Bird.rawValue || contact.bodyB.collisionBitMask == colliderType.Bird.rawValue {
            score += 1
            scoreLabel.text = String(score)
        }
    }
}
