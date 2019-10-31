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
    
    var showProgress: Observable<Bool> { get }
    var artistsList: BehaviorSubject<[Artist]> { get }
    var artistSongsList: PublishSubject<[SongEntity]> { get }
    var error: PublishSubject<Error> { get }
    func loadMoreCells(prefetchRowsAt indexPaths: [IndexPath])
}

final class ArtistsListViewModel: ArtistsViewModel {
    var showProgress: Observable<Bool> {
        showLoader.asObservable()
    }
    
    // MARK: private state
    
    private let disposeBag = DisposeBag()
    private let apiClient: ApiClient
    private var page = Page()
    private var allSongsList: [SongEntity] = []
    private var currentUser: Artist?
    
    // MARK: Observers
    
    let artistsList = BehaviorSubject<[Artist]>(value: [])
    let artistSongsList = PublishSubject<[SongEntity]>()
    private let showLoader = PublishSubject<Bool>()
    let error = PublishSubject<Error>()
    
    /// initializier
    /// - Parameter apiClient: network handler
    init(apiClient: ApiClient = HTTPClient()) {
        self.apiClient = apiClient
    }
    
    /// load the data from the endpoint
    /// - Parameter showLoader: show indicator on screen to till user data is loading
    func loadData(showLoader: Bool = true) {
        guard page.shouldLoadMore else {
            return
        }
        page.isFetchingData = true
        showLoader ? self.showLoader.onNext(true) : ()
        apiClient.getData(of: SongsApi.feed(type: "popular", page: page.currentPage, count: page.countPerPage))
            .subscribe(onNext: { [unowned self] value in
                self.allSongsList.append(contentsOf: value ?? [])
                if showLoader {
                    self.showLoader.onNext(false)
                }
                self.page.isFetchingData = false
                self.page.currentPage += 1
                self.updateUIWithArtists()
                
                }, onError: { err in
                    self.error.onNext(err)
            }).disposed(by: disposeBag)
    }
    
    /// emit values to ui to fill the table view if the data is a littlet reload untill fill the table
    private func updateUIWithArtists() {
        let artists = sortMusicByArtist(allSongsList)
        artistsList.onNext(artists)
        page.fetchedItemsCount = artists.count
    }

    
    /// group the songs by artist
    /// - Parameter list: list of songs for every Artist
    func sortMusicByArtist(_ list: SongsList) -> [Artist] {
        var users: [String: Artist] = [:]
        for song in list {
            if var user = users[song.userId ?? ""] {
                user.songsCount += 1
                users[song.userId ?? ""] = user
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
        currentUser = user
        let songs = allSongsList.filter { $0.userId == user.id }
        artistSongsList.onNext(songs)
    }
    
    func loadMoreCells(prefetchRowsAt indexPaths: [IndexPath]) {
        if indexPaths.contains(where: isLoadingCell) {
            loadData(showLoader: false)
        }
    }
    
    private func isLoadingCell(for indexPath: IndexPath) -> Bool {
        return indexPath.row + 15 >= page.fetchedItemsCount
    }
}
