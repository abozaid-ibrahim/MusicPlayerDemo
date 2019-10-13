//
//  SongsViewModel.swift
//  MusicPlayerDemo
//
//  Created by abuzeid on 10/12/19.
//  Copyright © 2019 abuzeid. All rights reserved.
//

import Foundation
import RxSwift

protocol SongsViewModel {}

class SongsListViewModel: SongsViewModel {
    private let disposeBag = DisposeBag()
    var showProgress = PublishSubject<Bool>()
    var songsList = BehaviorSubject<ArtistsRespose>(value: [])

    private var player: AudioPlayer
    var currentUser: User?
    init(player: AudioPlayer, songs: Observable<[FeedResposeElement]>) {
        self.player = player
        songs.bind(to: songsList).disposed(by: disposeBag)
    }

    func playSong(action: Observable<IndexPath>) {
        Observable.combineLatest(songsList, action)
            //            .map {  }
            .subscribe(onNext: { [unowned self] value, _ in
                let songs = value.map { URL(string: $0.streamUrl ?? "")! }
                self.player.playAudio(songs)
            }).disposed(by: disposeBag)
    }
}
