//
//  SongsDestination.swift
//  MusicPlayerDemo
//
//  Created by Abuzeid on 1/9/20.
//  Copyright © 2020 abuzeid. All rights reserved.
//

import Foundation
import UIKit
extension Destination {
     func getSongsView(artist: Artist?, album: Album, dataType: ScreenDataType) -> UIViewController {
        let songsVC = SongsView()
        songsVC.title = album.name
        songsVC.set(controller: SongsController(album: album, artist: artist, type: dataType, view: songsVC))
        return songsVC
    }
}
