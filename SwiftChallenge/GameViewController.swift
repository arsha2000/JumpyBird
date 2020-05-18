//
//  GameViewController.swift
//  SwiftChallenge
//
//  Created by Arsha Hassas on 5/9/20.
//  Copyright © 2020 Arsha Hassas. All rights reserved.
//

import UIKit
import SpriteKit
import ARKit
import GameplayKit

final class GameViewController: UIViewController {
    
    private(set) var sceneView: ARSKView!

    
//    override func loadView() {
//        
//        sceneView = ARSKView(frame: .init(x: 0, y: 0, width: 500, height: 600))
//        sceneView.delegate = self
//        sceneView.showsFPS = true
//        sceneView.showsNodeCount = true
//        
//        self.view = sceneView
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        
        // Load 'GameScene.sks' as a GKScene. This provides gameplay related content
        // including entities and graphs.
        
        let scene = GameScene(size: self.view.bounds.size)
        
            
            // Get the SKScene from the loaded GKScene
            
                
                // Copy gameplay related content over to the scene
                
                
                // Set the scale mode to scale to fit the window
                scene.scaleMode = .aspectFill
                
                // Present the scene
                if let view = self.view as! SKView? {
                    view.presentScene(scene)
                    
                    view.ignoresSiblingOrder = true
                    
                    view.showsFPS = true
                    view.showsNodeCount = true
                }
            
        
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        if let skView = self.view as? SKView,
            let scene = skView.scene {
            scene.size = skView.bounds.size
        }
    }

    override var shouldAutorotate: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .landscape
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}


extension GameViewController: ARSKViewDelegate {
    
}

extension GameViewController: ARSessionDelegate {
    
}
