//
//  GameScene.swift
//  SwiftChallenge
//
//  Created by Arsha Hassas on 5/9/20.
//  Copyright © 2020 Arsha Hassas. All rights reserved.
//

import SpriteKit
import GameplayKit

final class GameScene: SKScene {
    
    // MARK: - Types
    enum Audio: String, CaseIterable {
        case jump, score, hurt, background
        
        var url: URL {
            return Bundle.main.url(forResource: self.rawValue, withExtension: "wav")!
        }
    }
    
    // MARK: - Properties
    var entities = [GKEntity]()
    let infiniteLoopComponentSystem = GKComponentSystem(componentClass: InfiniteLoopComponent.self)
    
    private(set) var audios: [Audio : SKAudioNode] = [:]
    
    private var backgroundNode: SKSpriteNode!
    private var lastUpdateTime : TimeInterval = 0
    private var stateMachine: GKStateMachine!
    
    
    
    // MARK: - Life Cycle
    override func sceneDidLoad() {
        
        self.lastUpdateTime = 0
        self.anchorPoint = .init(x: 0.5, y: 0.5)
        
        addBackground()
        addGround()
        addAudioNodes()
        
        self.physicsWorld.gravity = .init(dx: 0, dy: -5)
        self.physicsWorld.contactDelegate = self
    }
    
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        
        self.stateMachine = .init(states: [
            StartState(gameScene: self),
            PlayState(gameScene: self),
            ScoreState(gameScene: self)
        ])
        
        self.stateMachine.enter(StartState.self)
        
        self.audios[.background]?.autoplayLooped = true
        self.audios[.background]?.run(.play())
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        
        // Initialize _lastUpdateTime if it has not already been
        if (self.lastUpdateTime == 0) {
            self.lastUpdateTime = currentTime
        }
        
        // Calculate time since last update
        let dt = currentTime - self.lastUpdateTime
        
        // Update entities
        for entity in self.entities {
            entity.update(deltaTime: dt)
        }
        
        // Update Component System
        infiniteLoopComponentSystem.update(deltaTime: dt)
        
        // Update State Machine
        self.stateMachine.update(deltaTime: dt)
        
        
        self.lastUpdateTime = currentTime
    }
    
    // MARK: Touch Handling
    func touchUp(atPoint pos : CGPoint) {
        if let currentState = stateMachine.currentState as? Tappable {
            currentState.tapped(location: pos)
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
}

extension GameScene {
    
    // MARK: Audio
    private func addAudioNodes() {
        for audio in Audio.allCases {
            let node = SKAudioNode(url: audio.url)
            node.autoplayLooped = false
            node.isPositional = false
            
            audios[audio] = node
            self.addChild(node)
        }
    }
    
    private var backgroundDefaultPosition: CGPoint {
        return .init(x: (backgroundNode.size.width - self.size.width) / 2, y: 0)
    }
    
    private func addBackground() {
        
        let backgroundNode = BackgroundNode(sceneSize: self.size)
        let entity = GKEntity()
        
        let breakPosition = CGPoint(x: -self.size.width / 2 - 414 * backgroundNode.yScale, y: 0)
        let defaultPosition = CGPoint(x: -self.size.width / 2, y: 0)
        let loopComponent = InfiniteLoopComponent(scrollSpeed: Constant.backgroundSpeed,
                                                  breakPosition: breakPosition,
                                                  defaultPosition: defaultPosition)
        
        entity.addComponent(GeometryComponent(node: backgroundNode))
        entity.addComponent(loopComponent)
        infiniteLoopComponentSystem.addComponent(loopComponent)
        
        self.addChild(backgroundNode)
        self.backgroundNode = backgroundNode
        self.entities.append(entity)
    }
    
    private func addGround() {
        let ground = GroundNode(sceneSize: self.size)
        let entity = GKEntity()
        
        ground.position = CGPoint(x: self.size.width / 2,
                                  y: -(self.size.height / 2) + ground.size.height / 2)
        
        let loopComponent = InfiniteLoopComponent(scrollSpeed: Constant.groundSpeed,
                                                  breakPosition: .zero,
                                                  defaultPosition: ground.position)
        entity.addComponent(loopComponent)
        entity.addComponent(GeometryComponent(node: ground))
        infiniteLoopComponentSystem.addComponent(loopComponent)
        
        addChild(ground)
        entities.append(entity)
    }
    
}

// MARK: Physics Contact Delegate
extension GameScene: SKPhysicsContactDelegate {
    func didBegin(_ contact: SKPhysicsContact) {
        stateMachine.enter(ScoreState.self)
    }
}
