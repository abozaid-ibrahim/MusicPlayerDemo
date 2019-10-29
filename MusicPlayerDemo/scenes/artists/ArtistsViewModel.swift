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
    func loadData(showLoader: Bool,for artist:String)
    func songsOf(user: Artist)
    var showProgress: PublishSubject<Bool> { get }
    var artistsList: BehaviorSubject<[Artist]> { get }
    var artistSongsList: PublishSubject<[Artist]> { get }
    var error: PublishSubject<Error> { get }

    var currentCount: Int { get }
}

final class ArtistsListViewModel: ArtistsViewModel {
    // MARK: private state

    private let disposeBag = DisposeBag()
    private let apiClient: ApiClient
    private var page = 1
    private let countPerPage = 15
    private var allSongsList: [Artist] = []
    private var currentUser: Artist?
    private var isFetchingData = false

    // MARK: Observers

    var artistsList = BehaviorSubject<[Artist]>(value: [])
    var artistSongsList = PublishSubject<[Artist]>()
    var currentCount: Int = 0
    var showProgress = PublishSubject<Bool>()
    var error = PublishSubject<Error>()

    /// initializier
    /// - Parameter apiClient: network handler
    init(apiClient: ApiClient = HTTPClient()) {
        self.apiClient = apiClient
    }

    /// load the data from the endpoint
    /// - Parameter showLoader: show indicator on screen to till user data is loading
    func loadData(showLoader: Bool ,for artist:String) {
        if self.isFetchingData {
            return
        }
        self.isFetchingData = true
        if showLoader {
            self.showProgress.onNext(true)
        }
//        self.apiClient.getData<ArtistsSearchRespose>(of: ArtistsApi.searchFor(artist: artist, page: page, count: countPerPage))
//            .subscribe(onNext: { [unowned self] value in
//                self.allSongsList.append(contentsOf: value ?? [])
//                if showLoader {
//                    self.showProgress.onNext(false)
//                }
//                self.isFetchingData = false
//                self.page += 1
//                self.updateUIWithArtists()
//
//            }, onError: { err in
//                self.error.onNext(err)
//            }).disposed(by: self.disposeBag)
    }

    /// emit values to ui to fill the table view if the data is a littlet reload untill fill the table
    private func updateUIWithArtists() {
    
//        self.artistsList.onNext(artists)
//        self.currentCount = artists.count
    }

   

    /// return songs list for th singer
    /// - Parameter user: the current user that will display his songs
    func songsOf(user: Artist) {
//        self.currentUser = user
//        let songs = self.allSongsList.filter { $0.userId == user.id }
//        self.artistSongsList.onNext(songs)
    }
}
