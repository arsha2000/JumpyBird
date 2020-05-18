//
//  ScoreComponent.swift
//  SwiftChallenge
//
//  Created by Arsha Hassas on 5/15/20.
//  Copyright © 2020 Arsha Hassas. All rights reserved.
//

import GameplayKit

/// Score Component triggers the *addScoresHandler* when the corresponding node has passed the bird
final class ScoreComponent: GKComponent {
    
    private var birdPassed = false { willSet {
        if birdPassed == false {
            addScoreHandler()
        }
        }}
    private let birdPosition: CGPoint
    private let addScoreHandler: () -> ()
    
    private var geometryComponent: GeometryComponent? {
        return entity?.component(ofType: GeometryComponent.self)
    }
    
    /// - Parameters:
    ///     - birdPosition: the position of the user controlled bird
    ///     - addScoreHandler: this method is invoked when the node has passed the bird
    init(birdPosition: CGPoint, addScoreHandler: @escaping () -> ()) {
        self.birdPosition = birdPosition
        self.addScoreHandler = addScoreHandler
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func update(deltaTime seconds: TimeInterval) {
        guard !birdPassed else { return }
        guard let node = geometryComponent?.node as? SKSpriteNode else { return }
        
        if (node.position.x + node.size.width / 2) < birdPosition.x {
            birdPassed = true
        }
    }
    
}
