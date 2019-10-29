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
 struct Response: Codable {
    public let topalbums: Topalbums?

    enum CodingKeys: String, CodingKey {
        case topalbums = "topalbums"
    }

    public init(topalbums: Topalbums?) {
        self.topalbums = topalbums
    }
}

// MARK: - Topalbums
public struct Topalbums: Codable {
    public let album: [Album]?
    public let attr: Attr?

    enum CodingKeys: String, CodingKey {
        case album = "album"
        case attr = "@attr"
    }

    public init(album: [Album]?, attr: Attr?) {
        self.album = album
        self.attr = attr
    }
}

// MARK: - Album
public struct Album: Codable {
    public let name: String?
    public let playcount: Int?
    public let mbid: String?
    public let url: String?
    public let artist: ArtistEntity?
    public let image: [Image]?

    enum CodingKeys: String, CodingKey {
        case name = "name"
        case playcount = "playcount"
        case mbid = "mbid"
        case url = "url"
        case artist = "artist"
        case image = "image"
    }

    public init(name: String?, playcount: Int?, mbid: String?, url: String?, artist: ArtistEntity?, image: [Image]?) {
        self.name = name
        self.playcount = playcount
        self.mbid = mbid
        self.url = url
        self.artist = artist
        self.image = image
    }
}

// MARK: - ArtistClass
public struct ArtistEntity: Codable {
    public let name: String?
    public let mbid: String?
    public let url: String?

    enum CodingKeys: String, CodingKey {
        case name = "name"
        case mbid = "mbid"
        case url = "url"
    }

    public init(name: String?, mbid: String?, url: String?) {
        self.name = name
        self.mbid = mbid
        self.url = url
    }
}
