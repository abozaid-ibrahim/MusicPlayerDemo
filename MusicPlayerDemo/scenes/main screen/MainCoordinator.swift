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
final class AppCoordinator: Coordinator {
    weak var window: UIWindow?

    private(set) weak var rootNavigationController: MainViewController?

    /// Creates a new instance of the App Coordinator
    ///
    /// - Parameter window: The main widnow of the application
    init(window: UIWindow?) {
        self.window = window
    }

    func start(completion: (() -> Void)?) {
        guard let window = self.window else { completion?(); return }
        let main = MainViewController()
        rootNavigationController = main
        
        window.rootViewController = rootNavigationController
        
        completion?()
    }

    func finish(completion: (() -> Void)?) {
        completion?()
    }
}
