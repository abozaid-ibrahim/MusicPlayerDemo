//
//  SongsJsonResponse.swift
//  MusicPlayerDemo
//
//  Created by abuzeid on 10/31/19.
//  Copyright © 2019 abuzeid. All rights reserved.
//

import Foundation


// MARK: - AlbumTracksResponse
struct AlbumTracksResponse: Codable {
    let album: SongAlbum?
    
    
    init(album: SongAlbum?) {
        self.album = album
    }
}

// MARK: - Album
struct SongAlbum: Codable {
    let name: String?
    let artist: String?
    let mbid: String?
    let url: String?
    let listeners: String?
    let playcount: String?
    let tracks: Tracks?
    let tags: Tags?
    let wiki: Wiki?
    
    
    
    init(name: String?, artist: String?, mbid: String?, url: String?,  listeners: String?, playcount: String?, tracks: Tracks?, tags: Tags?, wiki: Wiki?) {
        self.name = name
        self.artist = artist
        self.mbid = mbid
        self.url = url
        self.listeners = listeners
        self.playcount = playcount
        self.tracks = tracks
        self.tags = tags
        self.wiki = wiki
    }
}


// MARK: - Tags
struct Tags: Codable {
    let tag: [Tag]?
    
    
    init(tag: [Tag]?) {
        self.tag = tag
    }
}

// MARK: - Tag
struct Tag: Codable {
    let name: String?
    let url: String?
    
    enum CodingKeys: String, CodingKey {
        case name = "name"
        case url = "url"
    }
    
    init(name: String?, url: String?) {
        self.name = name
        self.url = url
    }
}

// MARK: - Tracks
struct Tracks: Codable {
    let track: [Track]?
    
    enum CodingKeys: String, CodingKey {
        case track = "track"
    }
    
    init(track: [Track]?) {
        self.track = track
    }
}

// MARK: - Track
struct Track: Codable {
    let name: String?
     let image: [SongImage]?
    let url: String?
    let duration: String?
    let attr: Attr?
    let streamable: Streamable?
    let artist: ArtistEntity?
    
    enum CodingKeys: String, CodingKey {
        case name = "name"
        case url = "url"
        case duration = "duration"
        case attr = "@attr"
        case streamable = "streamable"
        case artist = "artist"
        case image = "image"
    }
    
    init(name: String?, image:[SongImage]?,url: String?, duration: String?, attr: Attr?, streamable: Streamable?, artist: ArtistEntity?) {
        self.name = name
        self.url = url
        self.duration = duration
        self.attr = attr
        self.streamable = streamable
        self.artist = artist
        self.image = image
    }
}
// MARK: - Image
 struct SongImage: Codable {
     let text: String?

    
    enum CodingKeys: String, CodingKey {
        case text = "#text"
    }

     init(text: String?) {
        self.text = text
//        self.size = size
    }
}
// MARK: - Streamable
struct Streamable: Codable {
    let text: String?
    let fulltrack: String?
    
    enum CodingKeys: String, CodingKey {
        case text = "#text"
        case fulltrack = "fulltrack"
    }
    
    init(text: String?, fulltrack: String?) {
        self.text = text
        self.fulltrack = fulltrack
    }
}

// MARK: - Wiki
struct Wiki: Codable {
    let published: String?
    let summary: String?
    let content: String?
    init(published: String?, summary: String?, content: String?) {
        self.published = published
        self.summary = summary
        self.content = content
    }
}

