//
//  MiniPlayerViewController.swift
//  MusicPlayerDemo
//
//  Created by abuzeid on 10/12/19.
//  Copyright © 2019 abuzeid. All rights reserved.
//

import RxCocoa
import RxGesture
import RxSwift
import UIKit

/// mini view appears at the bottom of the application to show audio controls to the current song
final class MiniPlayerViewController: UIViewController {
    private let disposeBag = DisposeBag()

    // MARK: Outlets

    @IBOutlet private var playPauseBtn: UIButton!
    @IBOutlet private var forwardBtn: UIButton!
    @IBOutlet private var backwardBtn: UIButton!
    @IBOutlet private var titleLbl: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
    }

    /// bind view attributes to view model
    private func bind() {
        AudioPlayer.shared.state
            .bind(onNext: updateIcon(for:)).disposed(by: disposeBag)
        AudioPlayer.shared.playPause(playPauseBtn.rx.tapGesture().asObservable())
    }

    /// update mini player icons according to state recieved from the audio player
    /// - Parameter state: the new state of the audio player
    private func updateIcon(for state: AudioPlayer.State) {
        switch state {
        case .playing(let item):
            playPauseBtn.setImage(UIImage(named: "pauseIcon"), for: .normal)
            titleLbl.text = item.title
        case .paused(let item):
            playPauseBtn.setImage(UIImage(named: "playicon"), for: .normal)
            titleLbl.text = item.title
        default:
            print("TODO")
        }
    }
}
