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

class Album:Object, Codable {
    @objc dynamic var name: String? = .none
    @objc dynamic var playcount: Int = 0
    @objc dynamic var mbid: String? = .none
    @objc dynamic var url: String? = .none
    override static func primaryKey() -> String? {
        return "mbid"
    }
    @objc dynamic var artist: ArtistEntity? = .none
    var image:List<Image>? = List<Image>()

    convenience init(name: String?, playcount: Int, mbid: String?, url: String?, artist: ArtistEntity?, image:  List<Image>?) {
        self.init()
        self.name = name
        self.playcount = playcount
        self.mbid = mbid
        self.url = url
        self.artist = artist
        self.image = image
    }
}

// MARK: - ArtistClass

class ArtistEntity:Object, Codable {
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
 class Image:Object, Codable {
    @objc dynamic var text: String? = .none

    enum CodingKeys: String, CodingKey {
        case text = "#text"
    }

    convenience init(text: String?) {
        self.init()
        self.text = text
    }
}
