//
//  GroundNode.swift
//  SwiftChallenge
//
//  Created by Arsha Hassas on 5/15/20.
//  Copyright © 2020 Arsha Hassas. All rights reserved.
//

import SpriteKit

final class GroundNode: SKSpriteNode {
    
    private static let imageName = "ground"
    
    convenience init(sceneSize: CGSize) {
        self.init(imageNamed: GroundNode.imageName)
        self.name = "ground"
        self.anchorPoint = .init(x: 0.5, y: 0.5)
        self.zPosition = 2
        
        let groundScaleFactor = sceneSize.width / self.size.width * 2
        self.setScale(groundScaleFactor)
        
        self.physicsBody = .init(rectangleOf: self.size)
        self.physicsBody?.isDynamic = false
    }
    
}
