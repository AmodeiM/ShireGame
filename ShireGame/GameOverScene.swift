//
//  GameOverScene.swift
//  ShireGame
//
//  Created by Mariele Amodei on 11/4/22.
//

import Foundation
import SpriteKit

class GameOverScene: SKScene{
    init(size: CGSize, won:Bool){
        super.init(size:size)
        run(SKAction.playSoundFileNamed("gameOver.wav", waitForCompletion: false))
        let background = SKSpriteNode(imageNamed: "gameOver")
        background.position = CGPoint(x: frame.size.width/2, y: frame.size.height/2)
        background.size = CGSize(width: frame.size.width, height: frame.size.height)
        addChild(background)
        
        let message = won ? "You Won!" : "You lose :["
        
        let label = SKLabelNode(fontNamed: "Optima-ExtraBlack")
        label.text = message
        label.fontSize = 60
        label.fontColor = SKColor.black
        label.position = CGPoint(x: size.width/2, y: size.height/2 - 70)
        addChild(label)
        
        run(SKAction.sequence([
            SKAction.wait(forDuration: 3.0),
            SKAction.run() {[weak self] in
                
                guard let `self` = self else {return}
                let reveal = SKTransition.flipHorizontal(withDuration: 0.5)
                let scene = GameScene(size: size)
                self.view?.presentScene(scene, transition: reveal)
            }
        ]))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
