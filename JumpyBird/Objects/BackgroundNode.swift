//
//  BackgroundNode.swift
//  SwiftChallenge
//
//  Created by Arsha Hassas on 5/15/20.
//  Copyright © 2020 Arsha Hassas. All rights reserved.
//

import SpriteKit

final class BackgroundNode: SKSpriteNode {
    
    private static let imageName = "background"
    
    convenience init(sceneSize: CGSize) {
        self.init(imageNamed: BackgroundNode.imageName)
        
        self.name = BackgroundNode.imageName
        self.zPosition = -1
        self.anchorPoint = .init(x: 0, y: 0.5)
        self.position = .init(x: -sceneSize.width / 2, y: 0)

        let backgroundScaleFactor = sceneSize.height / self.size.height
        self.setScale(backgroundScaleFactor)
    }
    
}
