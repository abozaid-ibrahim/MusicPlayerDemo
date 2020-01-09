//
//  SongsController.swift
//  MusicPlayerDemo
//
//  Created by Abuzeid on 1/9/20.
//  Copyright © 2020 abuzeid. All rights reserved.
//

import Foundation

protocol SongsControllerType: class {
    func loadData()
    func changeOfflineMode()
    var tracksList: [Track] { get }
}

/// viewModel of songs list,
final class SongsController: SongsControllerType {
    private weak var view: SongsViewType!
    private var album: Album
    private var artist: Artist?
    private var apiClient: ApiClient
    private let repository: DataBaseOperations
    private let screenType: ScreenDataType
    private var albumTrack: AlbumTracks?
    private var isCached = false

    // MARK: UI notifier

    var tracksList: [Track] = []
    var error: Error!

    init(apiClient: ApiClient = AlamofireClient(),
         album: Album,
         artist: Artist?,
         repo: DataBaseOperations = RealmDb(),
         type: ScreenDataType,
         view: SongsViewType) {
        self.view = view
        self.album = album
        self.artist = artist
        self.apiClient = apiClient
        repository = repo
        screenType = type
        isCached = type == .offline ? true : false
    }

    func loadData() {
        view.setActionTitle(with: "Save")
        if let _ = self.repository.get(obj: Album.self, filter: "mbid", value: album.mbid) {
            view.setActionTitle(with: "Delete")
        }
        screenType == .online ? loadOnlineData() : loadOfflineData()
    }

    @objc func changeOfflineMode() {
        if isCached {
            repository.delete(obj: album)
            if let obj = self.albumTrack {
                repository.delete(obj: obj)
            }
            try? AppNavigator().back()

        } else {
            repository.save(obj: album)
            if let obj = self.albumTrack {
                repository.save(obj: obj)
            }
        }
        isCached.toggle()
        view.setActionTitle(with: isCached ? "Delete" : "Save")
    }
}

// MARK: AlbumsListViewModel (Private)

private extension SongsController {
    func loadOnlineData() {
        view.showLoading(show: true)
        let api = AlbumsApi.songs(artist: artist?.name, album: album.name ?? "")
        apiClient.getData(of: api) { [weak self] result in
            DispatchQueue.main.async { [weak self] in
                self?.updateUI(with: result)
            }
        }
    }

    private func updateUI(with result: Result<Data, Error>) {
        switch result {
        case let .success(data):
            view.showLoading(show: false)
            guard let value: AlbumTracksResponse = data.toModel() else {
                view.set(error: NetworkFailure.failedToParseData)
                return
            }
            albumTrack = value.album
            let objs = albumTrack?.tracks?.track
            tracksList = objs?.map { $0 } ?? []
            view.reloadData()

        case let .failure(err):
            view.set(error: err)
        }
    }

    func loadOfflineData() {
        let list = repository.get(obj: AlbumTracks.self, filter: "mbid", value: album.mbid)
        guard let tracks = list as? AlbumTracks,
            let result = tracks.tracks?.track else { return }
        albumTrack = tracks
        tracksList = Array(result)
        view.reloadData()
    }
}
