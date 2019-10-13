//
//  MiniPlayerViewController.swift
//  MusicPlayerDemo
//
//  Created by abuzeid on 10/12/19.
//  Copyright © 2019 abuzeid. All rights reserved.
//

import RxCocoa
import RxSwift
import UIKit

class MiniPlayerViewController: UIViewController {
    private let disposeBag = DisposeBag()
    @IBOutlet private var playPauseBtn: UIButton!
    @IBOutlet private var titleLbl: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        AudioPlayer.shared.state
            .bind(onNext: updateIcon(for:)).disposed(by: disposeBag)
    }

    func updateIcon(for state: AudioPlayer.State) {
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

    @IBAction func onPlayPauseClicked(_ sender: Any) {
        AudioPlayer.shared.playNext()
    }
}
