//
//  FeedCoordinator.swift
//  MusicPlayerDemo
//
//  Created by abuzeid on 10/13/19.
//  Copyright © 2019 abuzeid. All rights reserved.
//

import Foundation
import UIKit

class FeedCoordinator: FeedCoordinatorType {

    private weak var rootNavigationController: UINavigationController?

    /// Creates and returns a new coordinator
    ///
    /// - Parameter rootNavigationController: The root navigation controller
    init(rootNavigationController: UINavigationController?) {
        self.rootNavigationController = rootNavigationController
    }

    func start(completion: (() -> Void)?) {
        guard let rootNavigationController = rootNavigationController else { completion?(); return }
//        let socketManager = SocketManager()
//        let viewModel = MapViewModel(socketManager: socketManager, coordinator: self)
        let viewController = SongsViewController()//.instantiateFromStoryboard()
//        viewController.viewModel = viewModel
        rootNavigationController.setViewControllers([viewController], animated: false)
        completion?()
    }

    func finish(completion: (() -> Void)?) {
        completion?()
    }
}

protocol FeedCoordinatorType: Coordinator {
}
