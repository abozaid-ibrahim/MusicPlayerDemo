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

enum FeedType: String {
    case popular
}

protocol FeedViewModel {}

class FeedListViewModel: FeedViewModel {
    private let disposeBag = DisposeBag()
    var showProgress = PublishSubject<Bool>()
    private let network: HTTPClient
    var page = 0
    var countPerPage = 20
    var songsList = BehaviorSubject<ArtistsRespose>(value: [])
    var artist = PublishSubject<[SongEntity]>()

    var currentUser: Artist?

    init(apiClient: HTTPClient = HTTPClient()) {
        self.network = apiClient
    }

    func loadData() {
        self.showProgress.onNext(true)
        self.network.getData(of: Feed.feed(type: "popular", page: self.page, count: self.countPerPage))
            .subscribe(onNext: { [unowned self] value in
                self.songsList.onNext(value ?? [])
                self.showProgress.onNext(false)
            }).disposed(by: self.disposeBag)
    }

    func sortMusicByArtist(_ feed: ArtistsRespose) -> [Artist] {
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

        return users.values.map { $0 }
    }

    func songsOf(user: Artist) {
        self.currentUser = user
        self.songsList.map {
            $0.filter { $0.userId == user.id }
        }.bind(to: self.artist).disposed(by: self.disposeBag)
    }
}
