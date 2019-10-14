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

protocol ArtistsViewModel {
    func loadData(showLoader: Bool)
    func songsOf(user: Artist)
    func sortMusicByArtist(_ feed: SongsList) -> [Artist]
    var showProgress: PublishSubject<Bool> { get }
    var artistsList: BehaviorSubject<[Artist]> { get }
    var artistSongsList: PublishSubject<[SongEntity]> { get }
    var currentCount: Int { get }
}

final class ArtistsListViewModel: ArtistsViewModel {
    private let disposeBag = DisposeBag()
    var showProgress = PublishSubject<Bool>()
    private let network: HTTPClient
    private var page = 1
    private let countPerPage = 15
    var artistsList = BehaviorSubject<[Artist]>(value: [])
    var artistSongsList = PublishSubject<[SongEntity]>()
    private var allSongsList: [SongEntity] = []
    var currentCount: Int = 0

    var currentUser: Artist?
    var isFetchingData = false

    /// init
    /// - Parameter apiClient: network handler
    init(apiClient: HTTPClient = HTTPClient()) {
        self.network = apiClient
    }

    /// load the data from the endpoint
    /// - Parameter showLoader: show indicator on screen to till user data is loading
    func loadData(showLoader: Bool = true) {
        if self.isFetchingData {
            return
        }
        self.isFetchingData = true
        if showLoader {
            self.showProgress.onNext(true)
        }
        self.network.getData(of: SongsApi.feed(type: "popular", page: self.page, count: self.countPerPage))
            .subscribe(onNext: { [unowned self] value in
                self.allSongsList.append(contentsOf: value ?? [])
                if showLoader {
                    self.showProgress.onNext(false)
                }
                self.isFetchingData = false
                self.page += 1
                self.updateUIWithArtists()

            }).disposed(by: self.disposeBag)
    }

    /// emit values to ui to fill the table view if the data is a littlet reload untill fill the table
    private func updateUIWithArtists() {
        let artists = self.sortMusicByArtist(self.allSongsList)
        self.artistsList.onNext(artists)
        self.currentCount = artists.count
    }

    /// group the songs by artist
    /// - Parameter list: list of songs for every Artist
    func sortMusicByArtist(_ list: SongsList) -> [Artist] {
        var users: [String: Artist] = [:]
        for song in list {
            if var raw = users[song.userId ?? ""] {
                raw.songsCount += 1
                users[song.userId ?? ""] = raw
            } else {
                var user = song.user
                user?.songsCount += 1
                users[song.userId ?? ""] = user
            }
        }

        return users.values.sorted { $0.songsCount > $1.songsCount }
    }

    /// return songs list for th singer
    /// - Parameter user: the current user that will display his songs
    func songsOf(user: Artist) {
        self.currentUser = user
        let songs = self.allSongsList.filter { $0.userId == user.id }
        self.artistSongsList.onNext(songs)
    }
}
