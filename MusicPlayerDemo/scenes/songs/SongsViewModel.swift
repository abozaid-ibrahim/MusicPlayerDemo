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
    private var album: Album
    private var artist: Artist?
    private var apiClient: ApiClient
    private let repository: RealmDb
    private let screenType: ScreenDataType
    private var albumTrack: AlbumTracks?
    private var isCached = false { didSet { isCachedState.onNext(isCached) } }

    // MARK: UI notifier

    let tracksList = BehaviorSubject<[Track]>(value: [])
    let showProgress = PublishSubject<Bool>()
    let error = PublishSubject<Error>()
    let isCachedState = PublishSubject<Bool>()

    init(apiClient: ApiClient = HTTPClient(),
         album: Album,
         artist: Artist?,
         repo: RealmDb = RealmDb(),
         type: ScreenDataType) {
        self.album = album
        self.artist = artist
        self.apiClient = apiClient
        repository = repo
        screenType = type
        isCached = type == .offline ? true : false
    }

    func loadData() {
        screenType == .online ? loadOnlineData() : loadOfflineData()
    }
    private func loadOnlineData() {
        showProgress.onNext(true)
        let result: Observable<AlbumTracksResponse?> = apiClient.getData(of: AlbumsApi.songs(artist: artist?.name, album: album.name ?? ""))
        result.subscribe(onNext: { [unowned self] value in
            self.showProgress.onNext(false)
            self.albumTrack = value?.album
            let objs = self.albumTrack?.tracks?.track
            self.tracksList.onNext(objs?.map { $0 } ?? [])
        }, onError: { [unowned self] err in
            self.error.onNext(err)
        }).disposed(by: disposeBag)
    }
    private func loadOfflineData() {
        let list = repository.get(obj: AlbumTracks.self, filter: "mbid", value: album.mbid ?? "")
        guard let tracks = list as? AlbumTracks,
            let result = tracks.tracks?.track else { return }
        albumTrack = tracks
        tracksList.onNext(Array(result))
    }

    @objc func changeOfflineMode(sender _: Any) {
        if isCached {
            repository.delete(obj: album)
            if let obj = self.albumTrack {
                repository.delete(obj: obj)
            }
        } else {
            repository.save(obj: album)
            if let obj = self.albumTrack {
                repository.save(obj: obj)
            }
        }
        isCached.toggle()
    }

    func playSong(track _: Track) {
        //        let song =    SongEntity(streamUrl: track.url ?? "", title: track.name ?? "")
        //       AudioPlayer.shared.playAudio(form: [song] )
    }
}

enum ScreenDataType {
    case offline, online
}
