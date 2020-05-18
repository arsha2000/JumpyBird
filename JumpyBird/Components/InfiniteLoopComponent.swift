//
//  InfiniteLoopComponent.swift
//  SwiftChallenge
//
//  Created by Arsha Hassas on 5/11/20.
//  Copyright © 2020 Arsha Hassas. All rights reserved.
//

import GameplayKit

/// Infinite Loop Component creates the illusion of the corresponding node being continuous
///
final class InfiniteLoopComponent: GKComponent {
    
    enum Direction { case  left, right}
    
    let scrollSpeed: CGFloat
    let breakPosition: CGPoint
    let defaultPosition: CGPoint
    let scrollDirection: Direction
    var paused = false
    
    var geometryComponent: GeometryComponent? {
        return entity?.component(ofType: GeometryComponent.self)
    }
    
    /// - Parameters:
    ///     - scrollSpeed:  the speed at which the node is moved
    ///     - breakPosition: the point after which the node's position is set to the *defaultPosition*
    ///     - defaultPosition: the default position of the node
    ///
    init(scrollSpeed: CGFloat, breakPosition: CGPoint, defaultPosition: CGPoint) {
        self.scrollSpeed = scrollSpeed
        self.breakPosition = breakPosition
        self.defaultPosition = defaultPosition
        self.scrollDirection = scrollSpeed > 0 ? .right : .left
        super.init()
        
        self.geometryComponent?.move(to: defaultPosition)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func update(deltaTime seconds: TimeInterval) {
        guard !paused else { return }
        let position = geometryComponent?.node.position ?? defaultPosition
        var newPosition = CGPoint(x: position.x + scrollSpeed * CGFloat(seconds), y: position.y)
        
        // move to default position if the node has passed the break position
        switch scrollDirection {
        case .left:
            if newPosition.x < breakPosition.x {
                newPosition = defaultPosition
            }
        case .right:
            if newPosition.x > breakPosition.x {
                newPosition = defaultPosition
            }
        }
        
        geometryComponent?.move(to: newPosition)
    }
    
    
}
