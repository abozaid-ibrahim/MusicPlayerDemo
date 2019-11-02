//
//  MainCoordinator.swift
//  MusicPlayerDemo
//
//  Created by abuzeid on 10/12/19.
//  Copyright © 2019 abuzeid. All rights reserved.
//

import Foundation
import UIKit
enum Destination {
    case main,
    albums(artist:Artist),
    albumTracks(artist:Artist?,album:Album,dataType:ScreenDataType)
    
    func controller() -> UIViewController {
        switch self {
        case .main:
            let main = MainViewController()
            setMainContainer(mainController: main)
            
            return main
        case .albums(let artist):
            return getAlbums(with: artist)
            
        case .albumTracks(let artist, let album,let type):
            return  getSongsView(artist: artist, album: album, dataType: type)
        }
    }
    
}

extension Destination{
    private func getSongsView( artist: Artist?, album: Album, dataType: ScreenDataType)->UIViewController {
        let songsVC = SongsViewController()
        songsVC.title = album.name
        songsVC.viewModel = SongsListViewModel(album: album, artist: artist, type: dataType)
        return songsVC
    }
    
    private func getAlbums(with artist:Artist?)->UIViewController {
        let albumsController = AlbumsViewController()
        albumsController.title = artist == nil ? "Offline Albums" : artist?.name ?? ""
        albumsController.viewModel = AlbumsListViewModel(artist: artist)
        return albumsController
    }
    
    private func setMainContainer(mainController:MainViewController) {
        let navigationController = UINavigationController(rootViewController: getAlbums(with: nil))
        mainController.addChild(navigationController)
        mainController.loadViewIfNeeded()
        mainController.addToMainContainer(navigationController.view)
        navigationController.view.equalToSuperViewEdges()
    }
}
