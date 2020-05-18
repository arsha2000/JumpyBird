//
//  PlayerControllableComponent.swift
//  SwiftChallenge
//
//  Created by Arsha Hassas on 5/12/20.
//  Copyright © 2020 Arsha Hassas. All rights reserved.
//

import GameplayKit

/// Player Controllable Component makes the corresponding node user controllable
///
final class PlayerControllableComponent: GKComponent {
    
    
    private var geometryCompontent: GeometryComponent? {
        return entity?.component(ofType: GeometryComponent.self)
    }
    
    func jump() {
        let vector = CGVector(dx: 0, dy: 8)
        geometryCompontent?.node.physicsBody?.velocity = .zero
        geometryCompontent?.applyImpulse(vector)
    }
    
}
