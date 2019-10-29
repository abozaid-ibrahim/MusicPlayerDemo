//
//  Coordinator.swift
//  MusicPlayerDemo
//
//  Created by abuzeid on 10/29/19.
//  Copyright © 2019 abuzeid. All rights reserved.
//

import Foundation
protocol Coordinator: class {
    /// Starts the coordinator
    ///
    /// - Parameter completion: completion handler called after the coordinator has started
    func start(completion: (() -> Void)?)
    /// Finishes the coordinator
    ///
    /// - Parameter completion: completion handler called after the coordinator has finished
    func finish(completion: (() -> Void)?)
}

extension Coordinator {
    func start() {
        start(completion: nil)
    }

    func finish() {
        finish(completion: nil)
    }
}
