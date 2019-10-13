//
//  SongsCoordinator.swift
//  MusicPlayerDemo
//
//  Created by abuzeid on 10/13/19.
//  Copyright © 2019 abuzeid. All rights reserved.
//

import Foundation
import UIKit

class SongsCoordinator: SongsCoordinatorType {
    private weak var rootNavigationController: UINavigationController?

    /// Creates and returns a new coordinator
    ///
    /// - Parameter rootNavigationController: The root navigation controller
    init(rootNavigationController: UINavigationController?, songs: [FeedResposeElement]) {
        self.songs = songs
        self.rootNavigationController = rootNavigationController
    }

    var songs: [FeedResposeElement]
    func start(completion: (() -> Void)?) {
        guard let rootNavigationController = rootNavigationController else { completion?(); return }
        let viewController = SongsViewController()
//        viewController.viewModel = SongsListViewModel(songs: songs)
        rootNavigationController.setViewControllers([viewController], animated: false)
        completion?()
    }

    func finish(completion: (() -> Void)?) {
        completion?()
    }
}

protocol SongsCoordinatorType: Coordinator {}
