//
//  StartState.swift
//  SwiftChallenge
//
//  Created by Arsha Hassas on 5/11/20.
//  Copyright © 2020 Arsha Hassas. All rights reserved.
//

import Foundation
import GameplayKit

final class StartState: GKState {
    
    let gameScene: GameScene
    
    private let titleName = "titleLabel"
    private let subtitleName = "subtitleLabel"
    
    init(gameScene: GameScene) {
        self.gameScene = gameScene
    }
    
    override func didEnter(from previousState: GKState?) {
        addTitle()
        addSubtitle()
        
        let action = SKAction.scale(to: 1, duration: 0.3)
        
        let title = gameScene.childNode(withName: titleName)
        let subtitle = gameScene.childNode(withName: subtitleName)
        
        title?.setScale(0)
        subtitle?.setScale(0)
        
        title?.run(action)
        subtitle?.run(action)
    }
    
    override func willExit(to nextState: GKState) {
        moveAndRemoveNodes(withNames: [titleName, subtitleName])
    }
    
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        return stateClass is PlayState.Type
    }
    
    
    private func addTitle() {
        let position = CGPoint(x: 0, y: 20)
        let text = NSAttributedString(string: "Jumpy Bird",
                                      attributes: [.font: UIFont.systemFont(ofSize: 48, weight: .bold),
                                                   .strokeWidth: 8.0,
                                                   .foregroundColor: UIColor.white])
        
        addText(text, withName: titleName, at: position)
    }
    
    private func addSubtitle() {
        
        let string = NSAttributedString(string: "Tap to Start",
                                        attributes: [.font: UIFont.systemFont(ofSize: 24, weight: .semibold),
                                                     .foregroundColor: UIColor.white])
        let position = CGPoint(x: 0, y: -10)
        
        addText(string, withName: subtitleName, at: position)
    }
    
    private func addText(_ attributedString: NSAttributedString, withName name: String, at position: CGPoint) {
        let label = SKLabelNode()
        label.name = name
        label.position = position
        label.attributedText = attributedString
        label.zPosition = 2
        
        gameScene.addChild(label)
    }
    
    private func moveAndRemoveNodes(withNames names: [String]) {
        for name in names {
            guard let node = gameScene.childNode(withName: name) else { continue }
            
            let action = SKAction.sequence([
                .scale(to: 0, duration: 0.3),
                SKAction.removeFromParent()
            ])
            node.run(action)
        }
    }
}

extension StartState: Tappable {
    func tapped(location: CGPoint) {
        stateMachine?.enter(PlayState.self)
    }
}
