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
    func loadData()
    func songsOf(user: Artist)
    func sortMusicByArtist(_ feed: SongsList) -> [Artist]
    var showProgress: PublishSubject<Bool> { get }
    var songsList: BehaviorSubject<SongsList> { get }
    var artist: PublishSubject<[SongEntity]> { get }
}

final class ArtistsListViewModel: ArtistsViewModel {
    private let disposeBag = DisposeBag()
    var showProgress = PublishSubject<Bool>()
    private let network: HTTPClient
    private var page = 0
    private var countPerPage = 20
    var songsList = BehaviorSubject<SongsList>(value: [])
    var artist = PublishSubject<[SongEntity]>()

    var currentUser: Artist?

    init(apiClient: HTTPClient = HTTPClient()) {
        self.network = apiClient
    }

    func loadData() {
        self.showProgress.onNext(true)
        self.network.getData(of: SongsApi.feed(type: "popular", page: self.page, count: self.countPerPage))
            .subscribe(onNext: { [unowned self] value in
                self.songsList.onNext(value ?? [])
                self.showProgress.onNext(false)
            }).disposed(by: self.disposeBag)
    }

    func sortMusicByArtist(_ feed: SongsList) -> [Artist] {
        var users: [String: Artist] = [:]
        for song in feed {
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

    func songsOf(user: Artist) {
        self.currentUser = user
        self.songsList.map {
            $0.filter { $0.userId == user.id }
        }.bind(to: self.artist).disposed(by: self.disposeBag)
    }
}
