//
//  Tappable.swift
//  SwiftChallenge
//
//  Created by Arsha Hassas on 5/12/20.
//  Copyright © 2020 Arsha Hassas. All rights reserved.
//

import GameplayKit

/// A protocol used to receive touch inputs
protocol Tappable where Self: GKState {
    func tapped(location: CGPoint)
}
