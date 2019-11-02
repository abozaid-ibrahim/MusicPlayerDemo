//
//  FeedViewModel.swift
//  MusicPlayerDemo
//
//  Created by abuzeid on 10/12/19.
//  Copyright © 2019 abuzeid. All rights reserved.
//

import Foundation
import RxOptional
import RxSwift
import Realm
import RealmSwift
protocol AlbumsViewModel {
    var showProgress: PublishSubject<Bool> { get }
    var albums: BehaviorSubject<[Album]> { get }
    var error: PublishSubject<Error> { get }
    func showSongsList(album: Album)
    func showAlbums(of artist: Artist)
    func loadData(showLoader: Bool)
}

final class AlbumsListViewModel: AlbumsViewModel {
    // MARK: private state

    private let disposeBag = DisposeBag()
    private let apiClient: ApiClient
    private var currentArtist: Artist?
    private let repository: RealmDb

    // MARK: Observers

    let albums = BehaviorSubject<[Album]>(value: [])
    var showProgress = PublishSubject<Bool>()
    var error = PublishSubject<Error>()
    /// initializier
    /// - Parameter apiClient: network handler
    init(apiClient: ApiClient = AlamofireClient(), artist: Artist?, db: RealmDb = RealmDb()) {
        self.apiClient = apiClient
        currentArtist = artist
        repository = db
    }

    var screenDataType: ScreenDataType {
        return currentArtist == nil ? .offline : .online
    }

    func loadData(showLoader: Bool = true) {
        screenDataType == .offline ? loadOfflineData(showLoader) : loadOnlineData(showLoader)
    }

    func showAlbums(of artist: Artist) {
        try? AppNavigator().push(.albums(artist: artist))
    }

    func showSongsList(album: Album) {
        try? AppNavigator().push(.albumTracks(artist: currentArtist, album: album, dataType: screenDataType))
    }
}

// MARK: AlbumsListViewModel (Private)

extension AlbumsListViewModel {
    private func loadOfflineData(_: Bool) {
        let data = repository.getAll(of: Album.self)
        updateUIWithArtists(data as! [Album])
    }

    private func loadOnlineData(_ showLoader: Bool) {
        showLoader ? showProgress.onNext(true) : ()
        let result: Observable<AlbumsResponse?> = apiClient.getData(of: AlbumsApi.albumsFor(artist: currentArtist?.name ?? ""))
        result.subscribe(onNext: { [unowned self] value in
            showLoader ? self.showProgress.onNext(false) : ()
            self.updateUIWithArtists(value?.topalbums?.album ?? [])
        }, onError: { [unowned self] err in
            self.error.onNext(err)
        }).disposed(by: disposeBag)
    }

    /// emit values to ui to fill the table view if the data is a littlet reload untill fill the table
    private func updateUIWithArtists(_ albums: [Album]) {
        let sorted = albums.sorted(by: { $0.playcount > $1.playcount })
        self.albums.onNext(sorted)
    }
}
