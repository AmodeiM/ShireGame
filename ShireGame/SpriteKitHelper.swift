//
//  SpriteKitHelper.swift
//  ShireGame
//
//  Created by Mariele Amodei on 11/4/22.
//

import Foundation
import SpriteKit

// used for Z position of all the nodes
enum Layer:CGFloat{
    case background
    case foreground
    case player
    case collectible
    case ui
}

// SpriteKit Physics Categories
enum PhysicsCategory{
    static let none: UInt32 = 0
    static let player: UInt32 = 0b1
    static let collectible: UInt32 = 0b10
    static let foreground: UInt32 = 0b100
}
