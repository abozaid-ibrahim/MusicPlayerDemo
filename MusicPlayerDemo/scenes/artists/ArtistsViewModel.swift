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
    func loadData(showLoader: Bool, for artist: String)
    var showProgress: PublishSubject<Bool> { get }
    var artistsList: BehaviorSubject<[Artist]> { get }
    var artistSongsList: PublishSubject<[Artist]> { get }
    var error: PublishSubject<Error> { get }
    var currentCount: Int { get }
    func loadPages(for index:[IndexPath])
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
//    private let coordinator  = AlbumsCoordinator(UINavigationController())
    /// initializier
    /// - Parameter apiClient: network handler
    init(apiClient: ApiClient = HTTPClient()) {
        self.apiClient = apiClient
    }

    /// load the data from the endpoint
    /// - Parameter showLoader: show indicator on screen to till user data is loading
    func loadData(showLoader: Bool, for artist: String) {
        if isFetchingData {
            return
        }
        isFetchingData = true
        if showLoader {
            showProgress.onNext(true)
        }

        let result: Observable<ArtistsSearchRespose?> = apiClient.getData(of: ArtistsApi.searchFor(artist: artist, page: page, count: countPerPage))

        result.subscribe(onNext: { [unowned self] value in
            if showLoader {
                self.showProgress.onNext(false)
            }
            
            self.isFetchingData = false
            self.page += 1
            self.updateUIWithArtists(value?.results?.artistmatches?.artist)

        }, onError: { err in
            self.error.onNext(err)
        }).disposed(by: disposeBag)
    }

    func loadPages(for index:[IndexPath]){
        
    }
    /// emit values to ui to fill the table view if the data is a littlet reload untill fill the table
    private func updateUIWithArtists(_ artists: [Artist]?) {
        artistsList.onNext(artists ?? [])
    }

    
}
