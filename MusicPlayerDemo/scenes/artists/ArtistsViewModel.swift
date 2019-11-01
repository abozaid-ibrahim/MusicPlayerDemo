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
    var artistsList: Observable<[Artist]>{get}
    var error: PublishSubject<Error> { get }
    func loadCells(for indexPaths: [IndexPath])
    var textToSearch:BehaviorSubject<String?>{get }
    
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
    
    var artistsList: Observable<[Artist]>{
        return artistsListSubj.asObservable()
    }
    var showProgress = PublishSubject<Bool>()
    var error = PublishSubject<Error>()
    var textToSearch =  BehaviorSubject<String?>(value: .none)
    
    /// initializier
    /// - Parameter apiClient: network handler
    init(apiClient: ApiClient = HTTPClient()) {
        self.apiClient = apiClient
        textToSearch
            .throttle(DispatchTimeInterval.milliseconds(500) , scheduler: MainScheduler.instance)
            .bind(onNext: search(for:)).disposed(by: disposeBag)
    }
    func loadMoreData(for artist: String?) {
        loadData(for: artist,newSearch: false)
    }
    private func search(for text:String?){
        self.page.currentPage = 1
        loadData(for: text, newSearch: true)
    }
    func loadData(for artist: String?,newSearch:Bool ) {
        guard page.shouldLoadMore else { return   }
        page.isFetchingData = true
        showProgress.onNext(true)
        let result: Observable<ArtistsSearchRespose?> = apiClient.getData(of: ArtistsApi.searchFor(artist: artist ?? "", page: page.currentPage, count: page.countPerPage))
        result.subscribe(onNext: { [unowned self] value in
            self.showProgress.onNext(false)
            self.page.maxPages = (value?.results?.opensearchTotalResults.toInt)! / self.page.countPerPage
            self.updateUIWith(newSearchResult: false,artists: value?.results?.artistmatches?.artist ?? [])
            }, onError: {[unowned self] err in
                self.error.onNext(err)
        }).disposed(by: disposeBag)
    }
    func loadCells(for indexPaths: [IndexPath]) {
        if indexPaths.contains(where: shouldLoadMoreData) {
            loadMoreData(for: try! (self.textToSearch.value() ?? ""))
        }
    }
    
    private func shouldLoadMoreData(for indexPath: IndexPath) -> Bool {
        return (indexPath.row) >= page.fetchedItemsCount
    }
    /// emit values to ui to fill the table view if the data is a littlet reload untill fill the table
    private func updateUIWith(newSearchResult:Bool, artists: [Artist]) {
        if newSearchResult{
            artistsListSubj.onNext(artists )
        }else{//pagination
            artistsListSubj.scan(artists) { old, newValue  in
                var temp = old
                temp.append(contentsOf: newValue)
                return temp
            }.subscribe(onNext: {[unowned self] value in
                self.artistsListSubj.onNext(value)
            }).disposed(by: disposeBag)
            self.page.currentPage += 1
            self.page.fetchedItemsCount += artists.count
        }
        self.page.isFetchingData = false
        
    }
    
    
}
