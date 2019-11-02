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
    var showProgress: PublishSubject<Bool> { get }
    var artistsList: Observable<[Artist]> { get }
    var error: PublishSubject<Error> { get }
    var textToSearch: BehaviorSubject<String?> { get }
    func loadCells(for indexPaths: [IndexPath])
    func showAlbum(of artist:Artist)
}

final class ArtistsListViewModel: ArtistsViewModel {
    // MARK: private state
    
    private let disposeBag = DisposeBag()
    private let showLoader = PublishSubject<Bool>()
    private let apiClient: ApiClient
    private var allSongsList: [Artist] = []
    private var currentUser: Artist?
    private var page = Page()
    private var artistsListSubj = PublishSubject<[Artist]>()
    // MARK: Observers
    
    var artistsList: Observable<[Artist]> {
        return artistsListSubj.asObservable()
    }
    
    var showProgress = PublishSubject<Bool>()
    var error = PublishSubject<Error>()
    var textToSearch = BehaviorSubject<String?>(value: .none)
    
    init(apiClient: ApiClient = HTTPClient()) {
        self.apiClient = apiClient
        textToSearch
            .throttle(.milliseconds(500), scheduler: MainScheduler.asyncInstance)
            .bind(onNext: search(for:)).disposed(by: disposeBag)
    }
    
    func showAlbum(of artist:Artist){
        try? AppNavigator().push(.albums(artist: artist))
        
    }
    func loadData(for artist: String?, newSearch: Bool) {
        guard page.shouldLoadMore else { return }
        page.isFetchingData = true
        showProgress.onNext(true)
        let result: Observable<ArtistsSearchRespose?> = apiClient.getData(of:
            ArtistsApi.searchFor(artist: artist ?? "", page: page.currentPage, count: page.countPerPage))
        result.subscribe(onNext: { [unowned self] value in
            self.showProgress.onNext(false)
            self.updateUIWith(newSearchResult: newSearch, response: value?.results)
            }, onError: { [unowned self] err in
                self.showProgress.onNext(false)
                self.error.onNext(err)
        }).disposed(by: disposeBag)
    }
    
}
//MARK: Pagination
extension ArtistsListViewModel{
    func loadCells(for indexPaths: [IndexPath]) {
        if indexPaths.contains(where: shouldLoadMoreData) {
            loadMoreData(for: try! (textToSearch.value() ?? ""))
        }
    }
    
    private func shouldLoadMoreData(for indexPath: IndexPath) -> Bool {
        return (indexPath.row) >= page.fetchedItemsCount
    }
    private func loadMoreData(for artist: String?) {
        loadData(for: artist, newSearch: false)
    }
}
//MARK: AlbumsListViewModel (Private)
extension ArtistsListViewModel{
    
    private func search(for text: String?) {
        page.currentPage = 1
        loadData(for: text, newSearch: true)
    }
    /// emit values to ui to fill the table view if the data is a littlet reload untill fill the table
    private func updateUIWith(newSearchResult: Bool, response: ArtistsSearchResults?) {
        page.isFetchingData = false
        guard let results = response,
            let artists = results.artistmatches?.artist else { return }
        page.maxPages = results.opensearchTotalResults.toInt / page.countPerPage
        if newSearchResult {
            artistsListSubj.onNext(artists)
            page.fetchedItemsCount = artists.count
            
        } else { // pagination
            artistsListSubj.scan(artists) { old, newValue in
                var temp = old
                temp.append(contentsOf: newValue)
                return temp
            }.subscribe(onNext: { [unowned self] value in
                self.artistsListSubj.onNext(value)
            }).disposed(by: disposeBag)
            page.currentPage += 1
            page.fetchedItemsCount += artists.count
        }
    }
}
