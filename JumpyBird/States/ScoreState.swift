//
//  ScoreState.swift
//  SwiftChallenge
//
//  Created by Arsha Hassas on 5/11/20.
//  Copyright © 2020 Arsha Hassas. All rights reserved.
//

import Foundation
import GameplayKit

final class ScoreState: GKState {
    
    // MARK: - Properties
    let gameScene: GameScene
    var score = 0
    private let scoreLabel = SKLabelNode()
    
    init(gameScene: GameScene) {
        self.gameScene = gameScene
    }
    
    // MARK: - Life Cycle
    override func didEnter(from previousState: GKState?) {
        scoreLabel.attributedText = attributedText(for: "Score: \(score)")
        
        scoreLabel.position = .zero
        scoreLabel.setScale(0.5)
        
        gameScene.addChild(scoreLabel)
        
        scoreLabel.setScale(0)
        
        scoreLabel.run(.scale(to: 1, duration: 0.3))
    }
    
    
    override func willExit(to nextState: GKState) {
        removeScoreLabel()
    }
    
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        return stateClass is StartState.Type
    }
    
    // MARK: - Methods
    
    private func removeScoreLabel() {
        let action = SKAction.sequence([
            .scale(to: 0, duration: 0.3),
            .removeFromParent()
        ])
        scoreLabel.run(action)
    }
    
    private func attributedText(for string: String) -> NSAttributedString {
        let font = UIFont.systemFont(ofSize: 48, weight: .bold)
        return NSAttributedString.init(string: string, attributes: [.font: font, .foregroundColor: UIColor.white])
    }
    
}

// MARK: - Tappable Protocol
extension ScoreState: Tappable {
    func tapped(location: CGPoint) {
        stateMachine?.enter(StartState.self)
    }
}
