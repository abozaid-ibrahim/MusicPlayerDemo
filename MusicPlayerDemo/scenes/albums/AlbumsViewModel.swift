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
    var showProgress: PublishSubject<Bool> { get }
    var albums: BehaviorSubject<[Album]> { get }
    var error: PublishSubject<Error> { get }
    func showSongsList(album: Album)
    func changeOfflineMode(for album:Album, index:Int)
}

final class AlbumsListViewModel: AlbumsViewModel {
    // MARK: private state
    
    private let disposeBag = DisposeBag()
    private let apiClient: ApiClient
    private var currentArtist: Artist?
    private let repository = RealmDb()
    // MARK: Observers
    
    let albums = BehaviorSubject<[Album]>(value: [])
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
        if currentArtist == nil{
            loadOfflineData(showLoader)
        }else{
            loadOnlineData(showLoader)
        }
    }
    private func loadOfflineData(_ showLoader: Bool ){
        let data  = repository.getAll(of: Album.self)
        self.updateUIWithArtists(data as! [Album])
        
    }
    private func loadOnlineData(_ showLoader: Bool){
        if showLoader {
            self.showProgress.onNext(true)
        }
        let result :Observable<AlbumsResponse?> = apiClient.getData(of: AlbumsApi.albumsFor(artist: currentArtist?.name ?? ""))
        
        
        result.subscribe(onNext: { [unowned self] value in
            showLoader ? self.showProgress.onNext(false) : ()
            self.updateUIWithArtists(value?.topalbums?.album ?? [])
            }, onError: {[unowned self] err in
                self.error.onNext(err)
        }).disposed(by: self.disposeBag)
    }
    
    /// emit values to ui to fill the table view if the data is a littlet reload untill fill the table
    private func updateUIWithArtists(_ albums:[Album]) {
        let sorted = albums.sorted(by: { $0.playcount > $1.playcount})
        self.albums.onNext(sorted)
    }
    func changeOfflineMode(for album:Album, index:Int){
        //        if screenType == .online{
        //            repository.delete(obj: album)
        //        }else{
        //            repository.save(obj: album)
        //        }
    }
    func showSongsList(album: Album) {
        coordinator?.showTracks(of: currentArtist, album: album)
    }
    
    
}
