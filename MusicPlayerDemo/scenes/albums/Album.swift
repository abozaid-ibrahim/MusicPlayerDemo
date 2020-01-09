//
//  Album.swift
//  MusicPlayerDemo
//
//  Created by abuzeid on 11/1/19.
//  Copyright © 2019 abuzeid. All rights reserved.
//

import Foundation

import Realm
import RealmSwift

final class Album: Object, Codable {
    @objc dynamic var name: String? = .none
    @objc dynamic var playcount: Int = 0
    @objc dynamic var mbid: String = ""
    @objc dynamic var url: String? = .none
    @objc dynamic var artist: ArtistEntity? = .none
    var image: List<Image>? = List<Image>()
    override static func primaryKey() -> String? {
        return "mbid"
    }

    convenience init(name: String?, playcount: Int, mbid: String, url: String?, artist: ArtistEntity?, image: List<Image>?) {
        self.init()
        self.name = name
        self.playcount = playcount
        self.mbid = mbid
        self.url = url
        self.artist = artist
        self.image = image
    }
}

extension Album {
    convenience init(from decoder: Decoder) throws {
        self.init()
        let container = try decoder.container(keyedBy: CodingKeys.self)
        mbid = try container.decodeIfPresent(String.self, forKey: .mbid) ?? ""
        name = try container.decodeIfPresent(String.self, forKey: .name)
        playcount = try container.decodeIfPresent(Int.self, forKey: .playcount) ?? 0
        url = try container.decodeIfPresent(String.self, forKey: .url)
        image = try container.decodeIfPresent(List<Image>.self, forKey: .image)
        artist = try container.decodeIfPresent(ArtistEntity.self, forKey: .artist)
    }
}

// MARK: - ArtistClass

final class ArtistEntity: Object, Codable {
    @objc dynamic var name: String? = .none
    @objc dynamic var mbid: String? = .none
    @objc dynamic var url: String? = .none

    convenience init(name: String?, mbid: String?, url: String?) {
        self.init()
        self.name = name
        self.mbid = mbid
        self.url = url
    }
}

final class Image: Object, Codable {
    @objc dynamic var text: String? = .none

    enum CodingKeys: String, CodingKey {
        case text = "#text"
    }

    convenience init(text: String?) {
        self.init()
        self.text = text
    }
}
