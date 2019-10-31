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
    private var subView: UIView?
    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        addToMainContainer(self.subView)
        addMiniPlayer()
    }

    func addToMainContainer(_ subView: UIView?) {
        self.subView = subView
        if isViewLoaded {
            mainViewContainer.addSubview(subView!)
            subView?.equalToSuperViewEdges()
        }
    }
}

private extension MainViewController {
    private func addMiniPlayer() {
        let miniPlayer: MiniPlayerViewController = MiniPlayerViewController()
        addChild(miniPlayer)
        miniPlayerView.addSubview(miniPlayer.view)
        miniPlayer.view.equalToSuperViewEdges()
        AudioPlayer.shared.state.map { $0 == .sleep }.bind(to: miniPlayerView.rx.isHidden)
            .disposed(by: disposeBag)
    }
}
