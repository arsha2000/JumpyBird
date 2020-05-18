//
//  BirdNode.swift
//  SwiftChallenge
//
//  Created by Arsha Hassas on 5/14/20.
//  Copyright © 2020 Arsha Hassas. All rights reserved.
//

import SpriteKit
import GameplayKit

/// Bird Node is the main controllable node of the game
final class BirdNode: SKSpriteNode {
    
    static let imageName = "bird"
    
    convenience init() {
        self.init(imageNamed: BirdNode.imageName)
        
        self.name = BirdNode.imageName
        self.anchorPoint = .init(x: 0.5, y: 0.5)
        
        self.physicsBody = .init(rectangleOf: .init(width: self.size.width - 5, height: self.size.height - 5))
        self.physicsBody?.allowsRotation = false
        self.physicsBody?.contactTestBitMask = ContactCategory.categoryA
        self.physicsBody?.usesPreciseCollisionDetection = true
    }
}
