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
import RxGesture
final class MiniPlayerViewController: UIViewController {
    private let disposeBag = DisposeBag()
    @IBOutlet private var playPauseBtn: UIButton!
    @IBOutlet private var forwardBtn: UIButton!
    @IBOutlet private var backwardBtn: UIButton!

    
    @IBOutlet private var titleLbl: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
      bind()
    }
    private func bind(){
        AudioPlayer.shared.state
                  .bind(onNext: updateIcon(for:)).disposed(by: disposeBag)
        AudioPlayer.shared.playPause(playPauseBtn.rx.tapGesture().asObservable())
            
        
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

}
