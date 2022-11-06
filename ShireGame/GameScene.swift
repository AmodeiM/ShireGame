//
//  GameScene.swift
//  ShireGame
//
//  Created by Mariele Amodei on 11/3/22.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    let player = Player()
    var scoreBoard: SKLabelNode = SKLabelNode()
    var score : Int = 0{
        didSet{
            scoreBoard.text = "Score: \(score)"
        }
    }
    
    
    override func didMove(to view: SKView) {
        physicsWorld.contactDelegate = self
        let background = SKSpriteNode(imageNamed: "shire")
        background.position = CGPoint(x: frame.size.width/2, y: frame.size.height/2)
        background.size = CGSize(width: view.bounds.width, height: view.bounds.height)
        background.zPosition = Layer.background.rawValue
        addChild(background)
        
        let foreground = SKSpriteNode(imageNamed: "foreground")
        foreground.position = CGPoint(x: frame.size.width/2, y: 10)
        foreground.zPosition = Layer.foreground.rawValue
        
        // add physics body
        foreground.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: foreground.size.width, height: foreground.size.height))
        foreground.physicsBody?.affectedByGravity = false
        foreground.physicsBody?.categoryBitMask = PhysicsCategory.foreground
        foreground.physicsBody?.contactTestBitMask = PhysicsCategory.collectible
        foreground.physicsBody?.collisionBitMask = PhysicsCategory.none
        addChild(foreground)
        
        player.position = CGPoint(x: size.width/2, y: foreground.frame.maxY)
        player.setUpConstraints(floor: 5)
        addChild(player)
        
        spawnMultipleCollectibles()
        setUpLabels()
        
    }
    
    // Scoreboard
    func setUpLabels(){
        scoreBoard.name = "score"
        scoreBoard.fontName = "Optima-ExtraBlack"
        scoreBoard.fontColor = .black
        scoreBoard.fontSize = 55.0
        scoreBoard.horizontalAlignmentMode = .right
        scoreBoard.verticalAlignmentMode = .center
        scoreBoard.zPosition = Layer.ui.rawValue
        scoreBoard.position = CGPoint(x: frame.size.width - 50, y: frame.size.height - 50)
        scoreBoard.text = "Score: 0"
        addChild(scoreBoard)
    }
    
    // randomly spawn a ring or balrog
    func getCollectibleType() -> Collectible{
        // more rings than balrogs spawned
        let randomNumber = Int.random(in: 0...4)
        if randomNumber == 0{
            let collectible = Collectible(collectibleType: CollectibleType.balrog)
            return collectible
        }else {
            let collectible = Collectible(collectibleType: CollectibleType.ring)
            return collectible
        }
        
    }
    func spawnCollectible(collectible: Collectible){
        
        let margin = collectible.size.width * 2
        let dropRange = SKRange(lowerLimit: frame.minX + margin, upperLimit: frame.maxX - margin)
        let randomX = CGFloat.random(in: dropRange.lowerLimit...dropRange.upperLimit)
        collectible.position = CGPoint(x: randomX, y: frame.height)
        addChild(collectible)
        collectible.drop(dropSpeed: TimeInterval(1.0), floorLevel: player.frame.minY)
    }
    
    func spawnMultipleCollectibles(){
        
        //set up repeating action
        let wait = SKAction.wait(forDuration: TimeInterval(1.0))
        let spawn = SKAction.run { [self] in
            self.spawnCollectible(collectible: getCollectibleType())
        }
        let sequence = SKAction.sequence([wait, spawn])
        //let repeatAction = SKAction.repeat(sequence, count: 10)
        let repeatAction = SKAction.repeatForever(sequence)
        run(repeatAction, withKey: "spawn")
        
    }
    
    // determine which way player should face when user moves player
    func touchDown(atPoint pos: CGPoint){
        if pos.x < player.position.x {
            player.moveToPosition(pos: pos, direction: "L", speed: 1.0)
        }else {
            player.moveToPosition(pos: pos, direction: "R", speed: 1.0)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches{self.touchDown(atPoint: t.location(in: self))}
    }
    
    // GameOver Screen
    func gameOver(win: Bool){
        let reveal = SKTransition.flipHorizontal(withDuration: 0.5)
        let gameOverScene = GameOverScene(size: self.size, won: win)
        
        view?.presentScene(gameOverScene, transition: reveal)
    }
}

extension GameScene:SKPhysicsContactDelegate{
    func didBegin(_ contact: SKPhysicsContact) {
        let collision = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask
        if collision == PhysicsCategory.player | PhysicsCategory.collectible{
            print("Player hit collectible")
            let body = contact.bodyA.categoryBitMask == PhysicsCategory.collectible ? contact.bodyA.node : contact.bodyB.node
            //verify the object is a collectible
            if let sprite = body as? Collectible{
                if sprite.name! == "ring"{
                    run(SKAction.playSoundFileNamed("collectCoin.wav", waitForCompletion: false))
                    score+=1
                    
                    // Game runs until user hits balrog. Uncomment to let the user win if they collect 9 rings
                    //                    if score == 9{
                    //                        gameOver(win: true)
                    //                    }
                    // Game Over if user hits balrog
                } else if sprite.name! == "balrog"{
                    
                    gameOver(win: false)
                }
                sprite.collected()
            }
        }
        
        if collision == PhysicsCategory.foreground | PhysicsCategory.collectible{
            print("collectible hit foreground")
            
            let body = contact.bodyA.categoryBitMask == PhysicsCategory.collectible ? contact.bodyA.node : contact.bodyB.node
            
            //verify the object is a collectible
            if let sprite = body as? Collectible{
                sprite.missed()
            }
        }
        
    }
}

