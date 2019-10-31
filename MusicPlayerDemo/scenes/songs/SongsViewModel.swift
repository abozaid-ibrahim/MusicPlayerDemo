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
    var songsList = BehaviorSubject<[String]>(value: [])
    var artist = BehaviorSubject<Artist?>(value: .none)

    init(album: Album) {
//        songsList.onNext(songs)
//        artist.onNext(songs.first?.user)
    }

    /// fire audio player to start playing the seleced song
    /// - Parameter index: the item index that player should start playing from
    func playSong(index: IndexPath) {
//        songsList.subscribe(onNext: { value in
//            AudioPlayer.shared.playAudio(value)
//        }).disposed(by: disposeBag)
    }
}

extension String {
    /// convert string to formated duration
    var songDurationFormat: String {
        guard let seconds = Int(self) else {
            return String(format: "%02d:%02d:%02d", 0, 0, 0)
        }
        return String(format: "%02d:%02d:%02d", seconds / 3600, (seconds % 3600) / 60, (seconds % 3600) % 60)
    }
}
