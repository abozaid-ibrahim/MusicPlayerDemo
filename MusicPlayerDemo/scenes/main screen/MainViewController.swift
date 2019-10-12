//
//  MainViewController.swift
//  MusicPlayerDemo
//
//  Created by abuzeid on 10/12/19.
//  Copyright © 2019 abuzeid. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    @IBOutlet private var miniPlayerView: UIView!
    @IBOutlet private var mainViewContainer: UIView!

    // MARK: vars

    lazy var miniPlayer: MiniPlayerViewController = MiniPlayerViewController()
    lazy var feedsView = FeedViewController()
    override func viewDidLoad() {
        super.viewDidLoad()
        addFeedsView()

    }

    private func addFeedsView() {
        addChild(feedsView)
        mainViewContainer.addSubview(feedsView.view)
        feedsView.view.equalToSuperViewEdges()
    }

    private func addMiniPlayer() {
        addChild(miniPlayer)
        miniPlayerView.addSubview(miniPlayer.view)
        miniPlayer.view.equalToSuperViewEdges()
    }
}

extension MainViewController {}
