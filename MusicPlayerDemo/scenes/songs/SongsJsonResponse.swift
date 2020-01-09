//
//  SongsJsonResponse.swift
//  MusicPlayerDemo
//
//  Created by abuzeid on 10/31/19.
//  Copyright © 2019 abuzeid. All rights reserved.
//

import Foundation
import Realm
import RealmSwift

// MARK: - AlbumTracksResponse

struct AlbumTracksResponse: Codable {
    let album: AlbumTracks?
    init(album: AlbumTracks?) {
        self.album = album
    }
}

// MARK: - Album

class AlbumTracks: Object, Codable {
    @objc dynamic var name: String?
    @objc dynamic var artist: String?
    @objc dynamic var mbid: String?
    @objc dynamic var url: String?
    @objc dynamic var listeners: String?
    @objc dynamic var playcount: String?
    @objc dynamic var tracks: Tracks?

    convenience init(name: String?, artist: String?, mbid: String?, url: String?, listeners: String?, playcount: String?, tracks: Tracks?) {
        self.init()
        self.name = name
        self.artist = artist
        self.mbid = mbid
        self.url = url
        self.listeners = listeners
        self.playcount = playcount
        self.tracks = tracks
    }
}

// MARK: - Tracks

class Tracks: Object, Codable {
    var track: List<Track>? = List<Track>()
    convenience init(track: List<Track>?) {
        self.init()
        self.track = track
    }
}

// MARK: - Track

class Track: Object, Codable {
    @objc dynamic var name: String? = .none
    @objc dynamic var url: String? = .none
    @objc dynamic var duration: String? = .none

    convenience init(name: String?, url: String?, duration: String?) {
        self.init()
        self.name = name
        self.url = url
        self.duration = duration
    }
}
