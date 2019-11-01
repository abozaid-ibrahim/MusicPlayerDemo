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
    func playSong(track: Track)
    
}

/// viewModel of songs list,
final class SongsListViewModel: SongsViewModel {
    private let disposeBag = DisposeBag()
    var tracksList = BehaviorSubject<[Track]>(value: [])
    var showProgress = PublishSubject<Bool>()
    var error = PublishSubject<Error>()
    private var album:Album
    private var artist:Artist?
    private var apiClient:ApiClient
    init(apiClient: ApiClient = HTTPClient(),album: Album,artist:Artist?) {
        self.album = album
        self.artist = artist
        self.apiClient = apiClient
    }
    
    func loadData() {
        showProgress.onNext(true)
        let result: Observable<AlbumTracksResponse?> = apiClient.getData(of:AlbumsApi.songs(artist: artist?.name, album: album.name ?? ""))
        result.subscribe(onNext: { [unowned self] value in
            self.showProgress.onNext(false)
            self.tracksList.onNext(value?.album?.tracks?.track ?? [] )
            }, onError: { err in
                self.error.onNext(err)
        }).disposed(by: disposeBag)
    }
    
    
    
    /// fire audio player to start playing the seleced song
    /// - Parameter index: the item index that player should start playing from
    func playSong(track: Track) {
        let song =    SongEntity(streamUrl: track.url ?? "", title: track.name ?? "")
//       AudioPlayer.shared.playAudio(form: [song] )
        
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
