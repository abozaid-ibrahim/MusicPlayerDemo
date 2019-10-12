//
//  MainCoordinator.swift
//  MusicPlayerDemo
//
//  Created by abuzeid on 10/12/19.
//  Copyright © 2019 abuzeid. All rights reserved.
//

import Foundation

import UIKit

/// The App Coordinator creates the The Root ViewController of the Window
class AppCoordinator: Coordinator {

    weak var window: UIWindow?

    private(set) weak var rootNavigationController: UINavigationController?

    /// Creates a new instance of the App Coordinator
    ///
    /// - Parameter window: The main widnow of the application
    init(window: UIWindow?) {
        self.window = window
    }

    func start(completion: (() -> Void)?) {
        guard let window = self.window else { completion?(); return }

        let rootNavigationController = UINavigationController()
        self.rootNavigationController = rootNavigationController
        rootNavigationController.isNavigationBarHidden = true

        MapCoordinator(rootNavigationController: rootNavigationController).start {
            window.rootViewController = rootNavigationController
            completion?()
        }
    }

    func finish(completion: (() -> Void)?) {
        completion?()
    }
}
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

class MapCoordinator: MapCoordinatorType {

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
        let viewController = MainViewController()//.instantiateFromStoryboard()
//        viewController.viewModel = viewModel
        rootNavigationController.setViewControllers([viewController], animated: false)
        completion?()
    }

    func finish(completion: (() -> Void)?) {
        completion?()
    }
}

protocol MapCoordinatorType: Coordinator {
}
