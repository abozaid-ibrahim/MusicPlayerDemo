//
//  SongsViewModel.swift
//  MusicPlayerDemo
//
//  Created by abuzeid on 10/12/19.
//  Copyright © 2019 abuzeid. All rights reserved.
//

import Foundation
import RxSwift

protocol SongsViewModel {
    func playSong(index: IndexPath)
}

/// viewModel of songs list,
final class SongsListViewModel: SongsViewModel {
    private let disposeBag = DisposeBag()
    var showProgress = PublishSubject<Bool>()
    var songsList = BehaviorSubject<ArtistsRespose>(value: [])
    var artist = BehaviorSubject<Artist?>(value: .none)

    init(songs: [SongEntity]) {
        songsList.onNext(songs)
        artist.onNext(songs.first?.user)
    }

    /// fire audio player to start playing the seleced song
    /// - Parameter index: the item index that player should start playing from
    func playSong(index: IndexPath) {
        songsList.subscribe(onNext: { value in
            AudioPlayer.shared.playAudio(value)
        }).disposed(by: disposeBag)
    }
}
