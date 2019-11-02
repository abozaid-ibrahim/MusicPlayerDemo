//
//  SongsViewModel.swift
//  MusicPlayerDemo
//
//  Created by abuzeid on 10/12/19.
//  Copyright © 2019 abuzeid. All rights reserved.
//

import Foundation
import RxSwift

protocol SongsViewModel:class {
    var tracksList: BehaviorSubject<[Track]>{get}
    var showProgress: PublishSubject<Bool>{get}
    var error: PublishSubject<Error>{get}
    var isCachedState: BehaviorSubject<Bool>{get}
    func loadData()
    func changeOfflineMode()
    
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
    private var isCached = false
    
    // MARK: UI notifier
    
    let tracksList = BehaviorSubject<[Track]>(value: [])
    let showProgress = PublishSubject<Bool>()
    let error = PublishSubject<Error>()
    let isCachedState = BehaviorSubject<Bool>(value: false)
    
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
        isCachedState.onNext(isCached)
    }
    
    func loadData() {
        screenType == .online ? loadOnlineData() : loadOfflineData()
    }
 
    
    @objc func changeOfflineMode() {
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
        isCachedState.onNext(isCached)
    }
    
}
//MARK: AlbumsListViewModel (Private)
private extension SongsListViewModel{
     func loadOnlineData() {
         showProgress.onNext(true)
         let api = AlbumsApi.songs(artist: artist?.name, album: album.name ?? "")
         let result: Observable<AlbumTracksResponse?> = apiClient.getData(of: api)
         result.subscribe(onNext: { [unowned self] value in
             self.showProgress.onNext(false)
             self.albumTrack = value?.album
             let objs = self.albumTrack?.tracks?.track
             self.tracksList.onNext(objs?.map { $0 } ?? [])
             }, onError: { [unowned self] err in
                 self.error.onNext(err)
         }).disposed(by: disposeBag)
     }
      func loadOfflineData() {
         let list = repository.get(obj: AlbumTracks.self, filter: "mbid", value: album.mbid ?? "")
         guard let tracks = list as? AlbumTracks,
             let result = tracks.tracks?.track else { return }
         albumTrack = tracks
         tracksList.onNext(Array(result))
     }
}
