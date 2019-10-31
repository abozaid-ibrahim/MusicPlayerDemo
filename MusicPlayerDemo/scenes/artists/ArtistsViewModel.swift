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
    var artistsList: BehaviorSubject<[Artist]> { get }
    var artistSongsList: PublishSubject<[Artist]> { get }
    var error: PublishSubject<Error> { get }
    func loadCells(for indexPaths: [IndexPath])
    var textToSearch:BehaviorSubject<String?>{get }
    
}

final class ArtistsListViewModel: ArtistsViewModel {
    var textToSearch =  BehaviorSubject<String?>(value: .none)
    
    
    // MARK: private state
    
    private let disposeBag = DisposeBag()
    private let apiClient: ApiClient
    private var allSongsList: [Artist] = []
    private var currentUser: Artist?
    private var page = Page()
    
    
    // MARK: Observers
    
    var artistsList = BehaviorSubject<[Artist]>(value: [])
    var artistSongsList = PublishSubject<[Artist]>()
    var showProgress = PublishSubject<Bool>()
    var error = PublishSubject<Error>()
    //    private let coordinator  = AlbumsCoordinator(UINavigationController())
    /// initializier
    /// - Parameter apiClient: network handler
    init(apiClient: ApiClient = HTTPClient()) {
        self.apiClient = apiClient
        textToSearch
            .throttle(DispatchTimeInterval.milliseconds(1000) , scheduler: MainScheduler.instance)
            .bind(onNext: loadData(for:)).disposed(by: disposeBag)
    }
    func loadMoreData(for artist: String?) {
        loadData(for: artist)
    }
    /// load the data from the endpoint
    /// - Parameter showLoader: show indicator on screen to till user data is loading
    func loadData(for artist: String?) {
        guard let name = artist else{
            updateUI(with: true, artists: [])
            return
        }
        guard page.shouldLoadMore else {
            return
        }
        page.isFetchingData = true
        showProgress.onNext(true)
        
        let result: Observable<ArtistsSearchRespose?> = apiClient.getData(of: ArtistsApi.searchFor(artist: name, page: page.currentPage, count: page.countPerPage))
        
        result.subscribe(onNext: { [unowned self] value in
            
            self.showProgress.onNext(false)
            self.updateUI(with: true,artists: value?.results?.artistmatches?.artist ?? [])
            
            }, onError: { err in
                self.error.onNext(err)
        }).disposed(by: disposeBag)
    }
    func loadCells(for indexPaths: [IndexPath]) {
        if indexPaths.contains(where: shouldLoadMoreData) {
            loadData( for:try! (self.textToSearch.value() ?? ""))
        }
    }
    
    /// should load more items
    /// - Parameter indexPath: nearest unvisible indexpath
    private func shouldLoadMoreData(for indexPath: IndexPath) -> Bool {
        return (indexPath.row + 10) >= page.fetchedItemsCount
    }
    
    
    /// emit values to ui to fill the table view if the data is a littlet reload untill fill the table
    private func updateUI(with newSearchResult:Bool, artists: [Artist]) {
        if newSearchResult{
            artistsList.onNext(artists )
            self.page.isFetchingData = false
            
        }else{//pagination
            artistsList.onNext(artists )

//            artistsList.scan(artists) { (A, arts)  in
//
//            }
            self.page.isFetchingData = false
            self.page.currentPage += 1
            self.page.fetchedItemsCount += artists.count
            
        }
    }
    
    
}
