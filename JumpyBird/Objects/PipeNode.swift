//
//  Pipe.swift
//  SwiftChallenge
//
//  Created by Arsha Hassas on 5/14/20.
//  Copyright © 2020 Arsha Hassas. All rights reserved.
//

import SpriteKit
import GameplayKit

/// Pipe node defines the obstacles of the game.
/// - All Pipe node instaces use the same underlying texture for performance reasons
final class PipeNode: SKSpriteNode {
    
    private static let texture = SKTexture(imageNamed: "pipe")
    
    convenience init() {
        self.init(texture: PipeNode.texture)
        self.zPosition = 1
        
        self.physicsBody = .init(rectangleOf: self.size)
        self.physicsBody?.isDynamic = false
        self.physicsBody?.contactTestBitMask = ContactCategory.categoryA
    }
    
}
