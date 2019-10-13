//
//  MiniPlayerViewModel.swift
//  MusicPlayerDemo
//
//  Created by abuzeid on 10/13/19.
//  Copyright © 2019 abuzeid. All rights reserved.
//

import Foundation
import RxSwift
import RxOptional

protocol PlayerViewModel {}

class MiniPlayerViewModel: PlayerViewModel {
    private let disposeBag = DisposeBag()
    var songsList = BehaviorSubject<ArtistsRespose>(value: [])

    private var player: AudioPlayer
    var currentUser: User?
    init(player: AudioPlayer, songs: [FeedResposeElement]) {
        self.player = player
        songsList.onNext(songs)
    }

    func playSong(index: IndexPath) {
        songsList.subscribe(onNext: { [unowned self] value in
            self.player.playAudio(value, startFrom: index.row)
        }).disposed(by: disposeBag)
    }
}
