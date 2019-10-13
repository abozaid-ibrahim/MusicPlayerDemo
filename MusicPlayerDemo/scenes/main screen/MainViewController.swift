//
//  MainViewController.swift
//  MusicPlayerDemo
//
//  Created by abuzeid on 10/12/19.
//  Copyright © 2019 abuzeid. All rights reserved.
//

import RxSwift
import UIKit
class MainViewController: UIViewController {
    @IBOutlet private var miniPlayerView: UIView!
    @IBOutlet private var mainViewContainer: UIView!
    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        addFeedsView()
        addMiniPlayer()
    }
}

private extension MainViewController {
    private func addFeedsView() {
        let feedsView = FeedViewController()
        feedsView.title = "Music"
        let navigationController = UINavigationController(rootViewController: feedsView)
        addChild(navigationController)
        mainViewContainer.addSubview(navigationController.view)
        navigationController.view.equalToSuperViewEdges()
    }

    private func addMiniPlayer() {
        let miniPlayer: MiniPlayerViewController = MiniPlayerViewController()
        addChild(miniPlayer)
        miniPlayerView.addSubview(miniPlayer.view)
        miniPlayer.view.equalToSuperViewEdges()

        AudioPlayer.shared.state
            .map {
                if case .sleep = $0 {
                    return true
                } else {
                    return false
                }
            }
            .bind(to: miniPlayerView.rx.isHidden)
            .disposed(by: disposeBag)
    }
}
