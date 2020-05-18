//
//  GeometryComponent.swift
//  SwiftChallenge
//
//  Created by Arsha Hassas on 5/11/20.
//  Copyright © 2020 Arsha Hassas. All rights reserved.
//

import GameplayKit

/// Geometry Component defines the geometry of the corresponding node
final class GeometryComponent: GKComponent {
    
    
    let node: SKNode
    
    /// - Parameter node: the node for which the component is responsible
    init(node: SKNode) {
        self.node = node
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("Not implemented")
    }
    
    override func update(deltaTime seconds: TimeInterval) {
        super.update(deltaTime: seconds)
    }
    
    func move(to position: CGPoint) {
        self.node.position = position
    }
    
    func applyImpulse(_ vector: CGVector) {
        node.physicsBody?.applyImpulse(vector)
    }
    
}
