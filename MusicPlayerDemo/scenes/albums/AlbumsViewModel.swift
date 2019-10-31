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

protocol AlbumsViewModel {
    func loadData(showLoader: Bool)
    func songsOf(user: Artist)
    var showProgress: PublishSubject<Bool> { get }
    var albums: BehaviorSubject<[Album]> { get }
    var error: PublishSubject<Error> { get }

    var currentCount: Int { get }
}

final class AlbumsListViewModel: AlbumsViewModel {
    // MARK: private state

    private let disposeBag = DisposeBag()
    private let apiClient: ApiClient
    private var page = 1
    private let countPerPage = 15
    private var currentArtist: Artist?
    private var isFetchingData = false

    // MARK: Observers

    let albums = BehaviorSubject<[Album]>(value: [])
    var currentCount: Int = 0
    var showProgress = PublishSubject<Bool>()
    var error = PublishSubject<Error>()
    var coordinator:AlbumsCoordinator?
    /// initializier
    /// - Parameter apiClient: network handler
    init(apiClient: ApiClient = HTTPClient(),artist:Artist? = .none,co:AlbumsCoordinator) {
        self.apiClient = apiClient
        self.currentArtist = artist
        self.coordinator = co
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
        let result :Observable<AlbumsResponse?> = apiClient.getData(of: AlbumsApi.albumsFor(artist: currentArtist?.name ?? "", page: 0, count: 0))
        
        
       result.subscribe(onNext: { [unowned self] value in
        
                
        
                if showLoader {
                    self.showProgress.onNext(false)
                }
                self.isFetchingData = false
                self.page += 1
                self.updateUIWithArtists(value?.topalbums)

            }, onError: { err in
                self.error.onNext(err)
            }).disposed(by: self.disposeBag)
    }

    /// emit values to ui to fill the table view if the data is a littlet reload untill fill the table
    private func updateUIWithArtists(_ albums:Topalbums?) {
        self.albums.onNext(albums?.album ?? [])
//        self.currentCount = artists.count
    }

 
    /// return songs list for th singer
    /// - Parameter user: the current user that will display his songs
    func songsOf(user: Artist) {

        
    }
}
