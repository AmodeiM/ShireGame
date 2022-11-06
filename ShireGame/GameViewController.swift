//
//  GameViewController.swift
//  ShireGame
//
//  Created by Mariele Amodei on 11/3/22.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        if let view = self.view as! SKView?{

            let scene = GameScene(size: CGSize(width: view.bounds.width, height: view.bounds.height))
            scene.scaleMode = .aspectFill
            print(scene.size.width)
            print(scene.size.height)

            view.presentScene(scene)
            
            view.ignoresSiblingOrder = false
            view.showsPhysics = false
            view.showsFPS = true
            view.showsNodeCount = true
        }
       
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .landscape
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}
