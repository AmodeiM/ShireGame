//
//  Collectible.swift
//  ShireGame
//
//  Created by Mariele Amodei on 11/4/22.
//

import Foundation
import SpriteKit

enum CollectibleType: String{
    case none
    case ring
    case balrog
}

class Collectible:SKSpriteNode{
    private var collectibleType: CollectibleType = .none
    
    init(collectibleType: CollectibleType) {
        var texture: SKTexture!
        self.collectibleType = collectibleType
        
        //set the texture based on the Type
        switch self.collectibleType{
        case .ring:
            texture = SKTexture(imageNamed: "ring")
        case .balrog:
            texture = SKTexture(imageNamed: "balrog")
        case .none:
            break
        }
        
        super.init(texture: texture, color: .clear, size: texture.size())
        
        // set up the collectible
        self.name = "\(collectibleType)"
        self.anchorPoint = CGPoint(x: 0.5, y: 1.0)
        self.setScale(0.3)
        self.zPosition = Layer.collectible.rawValue
        
        // add physics body
        self.physicsBody = SKPhysicsBody(rectangleOf: self.size, center: CGPoint(x: 0.0, y: -self.size.height/2))
        //self.physicsBody?.affectedByGravity = false
        self.physicsBody?.isDynamic = false
        self.physicsBody?.categoryBitMask = PhysicsCategory.collectible
        self.physicsBody?.contactTestBitMask = PhysicsCategory.player | PhysicsCategory.foreground
        self.physicsBody?.collisionBitMask = PhysicsCategory.none
    }
    
    func drop(dropSpeed: TimeInterval, floorLevel: CGFloat){
        let pos = CGPoint(x: position.x, y: floorLevel)
        let scaleX = SKAction.scaleX(to: 0.25, duration: 1)
        let scaleY = SKAction.scaleY(to: 0.25, duration: 1)
        let scale = SKAction.group([scaleX, scaleY])
        
        let appear = SKAction.fadeAlpha(to: 1, duration: 0.25)
        let moveAction = SKAction.move(to: pos, duration: dropSpeed)
        let actionSequence = SKAction.sequence([appear, scale, moveAction])
        
        self.scale(to: CGSize(width: 0.25, height: 1.0))
        self.run(actionSequence, withKey: "drop")
    }
    
    func collected(){
        print("Collected")
        let removeFromParent = SKAction.removeFromParent()
        self.run(removeFromParent)
    }
    func missed(){
        print("missed")
        let removeFromParent = SKAction.removeFromParent()
        self.run(removeFromParent)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
