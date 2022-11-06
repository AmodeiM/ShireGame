//
//  Player.swift
//  ShireGame
//
//  Created by Mariele Amodei on 11/4/22.
//

import Foundation
import SpriteKit

class Player: SKSpriteNode{
    
    
    //MARK: - INIT
    init(){
        let texture = SKTexture(imageNamed: "gandalf")
        
        super.init(texture: texture, color: .clear, size: texture.size())
        
        self.name = "player"
        self.setScale(1.0)
        self.anchorPoint = CGPoint(x: 0.5, y: 0.0)
        self.zPosition = Layer.player.rawValue
        
        // add physics body
        self.physicsBody = SKPhysicsBody(rectangleOf: self.size, center: CGPoint(x: 0.5, y: self.size.height/2))
        self.physicsBody?.affectedByGravity = false
        //self.physicsBody?.isDynamic = true
        self.physicsBody?.categoryBitMask = PhysicsCategory.player
        self.physicsBody?.contactTestBitMask = PhysicsCategory.collectible
        self.physicsBody?.collisionBitMask = PhysicsCategory.none
    }
    
    //limit movement
    func setUpConstraints(floor: CGFloat){
        let range = SKRange(lowerLimit: floor, upperLimit: floor)
        print(floor)
        print(range)
        let lockToPlatform = SKConstraint.positionY(range)
        print(lockToPlatform)
        constraints = [lockToPlatform]
    }
    
    
    // Player movement
    func moveToPosition(pos: CGPoint, direction: String, speed: TimeInterval){
        //Set player's direction
        switch direction{
        case "L":
            xScale = abs(xScale)
        default:
            xScale = -abs(xScale)
        }
        
        let moveAction = SKAction.move(to: pos, duration: speed)
        run(moveAction)
    }
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
