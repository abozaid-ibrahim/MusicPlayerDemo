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
final class MainCoordinator: Coordinator {
    weak var window: UIWindow?

    private(set) weak var mainController: MainViewController?
    private let navigationController = UINavigationController()
    private lazy var albumsCoordinator: AlbumsCoordinator = {
        AlbumsCoordinator(navigationController)
    }()

    /// Creates a new instance of the App Coordinator
    ///
    /// - Parameter window: The main widnow of the application
    init(window: UIWindow?) {
        self.window = window
    }

    func start(completion: (() -> Void)?) {
        guard let window = self.window else { completion?(); return }
        let main = MainViewController()
        mainController = main
        window.rootViewController = mainController
        setMainContainer()
        showAlbums(for: nil)
        completion?()
    }

    func showAlbums(for artist: Artist?) {
        albumsCoordinator.start(completion: nil, for: artist)
    }

    private func setMainContainer() {
        mainController?.addChild(navigationController)
        mainController?.loadViewIfNeeded()
        mainController?.addToMainContainer(navigationController.view)
        navigationController.view.equalToSuperViewEdges()
    }

    func finish(completion: (() -> Void)?) {
        completion?()
    }
}
