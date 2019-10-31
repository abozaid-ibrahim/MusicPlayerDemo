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

    enum CodingKeys: String, CodingKey {
        case album = "album"
    }

     init(album: SongAlbum?) {
        self.album = album
    }
}

// MARK: - Album
 struct SongAlbum: Codable {
     let name: String?
     let artist: ArtistEnum?
     let mbid: String?
     let url: String?
     let listeners: String?
     let playcount: String?
     let tracks: Tracks?
     let tags: Tags?
     let wiki: Wiki?



     init(name: String?, artist: ArtistEnum?, mbid: String?, url: String?,  listeners: String?, playcount: String?, tracks: Tracks?, tags: Tags?, wiki: Wiki?) {
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

 enum ArtistEnum: String, Codable {
    case cher = "Cher"
}

// MARK: - Tags
 struct Tags: Codable {
     let tag: [Tag]?

    enum CodingKeys: String, CodingKey {
        case tag = "tag"
    }

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
    }

     init(name: String?, url: String?, duration: String?, attr: Attr?, streamable: Streamable?, artist: ArtistEntity?) {
        self.name = name
        self.url = url
        self.duration = duration
        self.attr = attr
        self.streamable = streamable
        self.artist = artist
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

    enum CodingKeys: String, CodingKey {
        case published = "published"
        case summary = "summary"
        case content = "content"
    }

     init(published: String?, summary: String?, content: String?) {
        self.published = published
        self.summary = summary
        self.content = content
    }
}

// MARK: - Encode/decode helpers

 class JSONNull: Codable, Hashable {

     static func == (lhs: JSONNull, rhs: JSONNull) -> Bool {
        return true
    }

     var hashValue: Int {
        return 0
    }

     func hash(into hasher: inout Hasher) {
        // No-op
    }

     init() {}

     required init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if !container.decodeNil() {
            throw DecodingError.typeMismatch(JSONNull.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for JSONNull"))
        }
    }

     func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encodeNil()
    }
}

class JSONCodingKey: CodingKey {
    let key: String

    required init?(intValue: Int) {
        return nil
    }

    required init?(stringValue: String) {
        key = stringValue
    }

    var intValue: Int? {
        return nil
    }

    var stringValue: String {
        return key
    }


}
