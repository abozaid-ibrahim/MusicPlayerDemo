//
//  ArtistCoordinator.swift
//  MusicPlayerDemo
//
//  Created by abuzeid on 10/31/19.
//  Copyright © 2019 abuzeid. All rights reserved.
//

import Foundation
import UIKit
/// The App Coordinator creates the The Root ViewController of the Window
final class ArtistCoordinator: Coordinator {
    func start(completion _: (() -> Void)?) {}

    private(set) weak var artistsController: ArtistsViewController?
    var nv: UINavigationController?
    init(_ nv: UINavigationController?) {
        self.nv = nv
    }

    func getArtistView() -> ArtistsViewController {
        let artistsController = ArtistsViewController()
        artistsController.title = "Your Albums"
        artistsController.viewModel = ArtistsListViewModel()
        return artistsController
    }

    func finish(completion: (() -> Void)?) {
        completion?()
    }
}
