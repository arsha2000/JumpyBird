//
//  PlayState.swift
//  SwiftChallenge
//
//  Created by Arsha Hassas on 5/11/20.
//  Copyright © 2020 Arsha Hassas. All rights reserved.
//

import Foundation
import GameplayKit

final class PlayState: GKState {

    // MARK: - Properties
    let gameScene: GameScene
    
    private let bird = GKEntity()
    private var pipes = [GKEntity]()
    private var scoreLabel = SKLabelNode()
    private var score = 0 { didSet{ updateLabel(with: score) }}
    
    // time for adding new pipes
    private var time: TimeInterval = 0
    
    // MARK: - Life Cycle
    init(gameScene: GameScene) {
        self.gameScene = gameScene
        super.init()
    }
    
    override func didEnter(from previousState: GKState?) {
        score = 0
        addBird()
        addLabel()
        updateLabel(with: score)
    }
    
    override func update(deltaTime seconds: TimeInterval) {
        
        // add new pipes every 3 seconds
        time += seconds
        if time > 3 {
            time = 0
            addPipes()
        }
        
        // remove off screen pipes
        pipes.removeAll { pipeEntity in
            let shouldRemove = pipeEntity.component(ofType: ScrollToAndRemoveComponent.self)?.removed ?? false
            return shouldRemove
        }
        
        bird.update(deltaTime: seconds)
        pipes.forEach { $0.update(deltaTime: seconds) }
        
    }
    
    override func willExit(to nextState: GKState) {
        remove(entities: pipes + [bird])
        pipes.removeAll()
        gameScene.removeChildren(in: [scoreLabel])
        
        // set the score on the next state
        if let next = nextState as? ScoreState {
            next.score = self.score
            self.gameScene.audios[.hurt]?.run(.play())
        }
    }
    
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        return stateClass is ScoreState.Type
    }
    
    
    // MARK: - Methods
    
    
    // MARK: Score Label
    private func addLabel() {
        scoreLabel.name = "scoreLabel"
        scoreLabel.zPosition = 10
        scoreLabel.position = CGPoint(x: 0, y: gameScene.size.height / 2 - 30)
        gameScene.addChild(scoreLabel)
    }
    
    private func updateLabel(with score: Int) {
        let string = "Score: \(score)"
        let attributedText = NSAttributedString(string: string, attributes: [.font: UIFont.systemFont(ofSize: 24, weight: .bold), .foregroundColor: UIColor.white])
        
        self.scoreLabel.attributedText = attributedText
    }
    
    // MARK: Pipe
    private func addPipes() {
        let pipeA = makePipe()
        let pipeB = makePipe()
        
        guard let nodeA = pipeA.component(ofType: GeometryComponent.self)?.node as? PipeNode else { return }
        guard let nodeB = pipeB.component(ofType: GeometryComponent.self)?.node as? PipeNode else { return }
        
        // randomized gap between the pipes
        let gap: CGFloat = 120 + CGFloat.random(in: -30...20)
        
        // rotate and flip the upper pipe
        nodeB.xScale = -1
        nodeB.run(.rotate(byAngle: .pi, duration: 0))
        
        // position the pipes
        let defaultPosition = CGPoint(x: gameScene.size.width / 2 + nodeA.size.width, y: CGFloat.random(in: -50...50))
        nodeA.position = .init(x: defaultPosition.x,
                               y: defaultPosition.y - (nodeA.size.height + gap) / 2)
        nodeB.position = .init(x: defaultPosition.x,
                               y: defaultPosition.y + (nodeB.size.height + gap) / 2)
        
        
        // add scoring behavior to the lower pipe
        pipeA.addComponent(
            ScoreComponent(birdPosition: .zero, addScoreHandler: { [weak self] in
                self?.score += 1
                self?.gameScene.audios[.score]?.run(.play())
            })
        )
        
        pipes.append(pipeA)
        pipes.append(pipeB)
        gameScene.addChild(nodeA)
        gameScene.addChild(nodeB)
        
    }
    
    private func makePipe() -> GKEntity {
        let pipeNode = PipeNode()
        
        let pipe = GKEntity()
        pipe.addComponent(GeometryComponent(node: pipeNode))
        // add scrolling behavior to the pipe
        pipe.addComponent(ScrollToAndRemoveComponent(scrollSpeed: Constant.pipeSpeed,
                                                     xRemovePoint: -(gameScene.size.width + pipeNode.size.width) / 2 ))
        
        return pipe
    }
    
    // MARK: Bird
    private func addBird() {
        let birdNode = BirdNode()
        birdNode.position = .zero
        
        bird.addComponent(GeometryComponent(node: birdNode))
        bird.addComponent(PlayerControllableComponent())
        
        birdNode.constraints = [
            .positionY(.init(upperLimit: gameScene.size.height / 2 + 40)),
            .positionX(.init(value: 0, variance: 0))
        ]
        
        gameScene.addChild(birdNode)
    }
    
    
    private func remove(entities: [GKEntity]) {
        let nodes = entities.compactMap { entity -> SKNode? in
            return entity.component(ofType: GeometryComponent.self)?.node
        }
        
        gameScene.removeChildren(in: nodes)
    }
    
}


// MARK: Tappable Protocol
extension PlayState: Tappable {
    func tapped(location: CGPoint) {
        bird.component(ofType: PlayerControllableComponent.self)?.jump()
        self.gameScene.audios[.jump]?.run(.play())
    }
}
