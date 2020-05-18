//
//  ScrollToAndRemoveComponent.swift
//  SwiftChallenge
//
//  Created by Arsha Hassas on 5/15/20.
//  Copyright © 2020 Arsha Hassas. All rights reserved.
//

import GameplayKit

/// Scroll to and Remove Component moves the corresponding node to the *xRemovePoint* and then removes the node from its parent
final class ScrollToAndRemoveComponent: GKComponent {
    
    private var geometryComponent: GeometryComponent? {
        return entity?.component(ofType: GeometryComponent.self)
    }
    
    let scrollSpeed: CGFloat
    let xRemovePoint: CGFloat
    private(set) var removed = false
    
    /// - Parameters:
    ///     - scrollSpeed: the speed at which the node is moves
    ///     - xRemovePoint: the point at which the node is removed
    ///
    init(scrollSpeed: CGFloat, xRemovePoint: CGFloat) {
        self.scrollSpeed = scrollSpeed
        self.xRemovePoint = xRemovePoint
        super.init()
    }
    
    
    override func update(deltaTime seconds: TimeInterval) {
        guard !removed else { return }
        guard let geometryComp = geometryComponent else { return }
        
        var newPosition = geometryComp.node.position
        newPosition.x += scrollSpeed * CGFloat(seconds)

        geometryComp.move(to: newPosition)

        if scrollSpeed < 0 {
            if newPosition.x < xRemovePoint {
                self.remove()
            }
        } else {
            if newPosition.x > xRemovePoint {
                self.remove()
            }
        }
        
    }
    
    private func remove() {
        self.geometryComponent?.node.run(.removeFromParent())
        self.removed = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
