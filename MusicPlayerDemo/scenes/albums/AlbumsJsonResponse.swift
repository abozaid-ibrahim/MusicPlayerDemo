//
//  FeedJsonResponse.swift
//  MusicPlayerDemo
//
//  Created by abuzeid on 10/12/19.
//  Copyright © 2019 abuzeid. All rights reserved.
//

import Foundation

import Foundation

// MARK: - Response

struct AlbumsResponse: Codable {
    let topalbums: Topalbums?

    init(topalbums: Topalbums?) {
        self.topalbums = topalbums
    }
}

// MARK: - Topalbums

struct Topalbums: Codable {
    let album: [Album]?
    let attr: Attr?

    enum CodingKeys: String, CodingKey {
        case album
        case attr = "@attr"
    }

    init(album: [Album]?, attr: Attr?) {
        self.album = album
        self.attr = attr
    }
}

// MARK: - Album

struct Album: Codable {
    let name: String?
    let playcount: Int?
    let mbid: String?
    let url: String?
    let artist: ArtistEntity?
    let image: [Image]?

    init(name: String?, playcount: Int?, mbid: String?, url: String?, artist: ArtistEntity?, image: [Image]?) {
        self.name = name
        self.playcount = playcount
        self.mbid = mbid
        self.url = url
        self.artist = artist
        self.image = image
    }
}

// MARK: - ArtistClass

struct ArtistEntity: Codable {
    let name: String?
    let mbid: String?
    let url: String?

    init(name: String?, mbid: String?, url: String?) {
        self.name = name
        self.mbid = mbid
        self.url = url
    }
}
