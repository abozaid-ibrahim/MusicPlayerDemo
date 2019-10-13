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
    private let network:HTTPClient
    var page = 0
    var countPerPage = 20
    var allSongsList = PublishSubject<ArtistsRespose>()
    var songsList = PublishSubject<ArtistsRespose>()
    var currentUser: User?
    init(apiClient: HTTPClient = HTTPClient()) {
        self.network = apiClient
    }

    var feedsList: Observable<[User]> {
        return Observable<[User]>.create { [unowned self] observer in

            self.showProgress.onNext(true)
            self.network.getData(of: Feed.feed(type: "popular", page: self.page, count: self.countPerPage))
                .subscribe(onNext: { [unowned self] value in
                    self.allSongsList.onNext(value ?? [])
                    observer.onNext(self.sortMusicByArtist(value ?? []))
                    self.showProgress.onNext(false)
                }).disposed(by: self.disposeBag)
            return Disposables.create()
        }
    }

    func sortMusicByArtist(_ feed: ArtistsRespose) -> [User] {
        var users: [String: User] = [:]
        for song in feed {
            if var raw = users[song.userId ?? ""] {
                raw.songsCount += 1
            } else {
                var user = song.user
                user?.songsCount += 1
                users[song.userId ?? ""] = user
            }
        }

        return users.values.map { $0 }
    }

    func songsOf(user: User) -> Observable<[FeedResposeElement]> {
        currentUser = user
        return allSongsList.map {
            $0.filter { $0.userId == user.id }
        }
    }
}
