//
//  FeedJsonResponse.swift
//  MusicPlayerDemo
//
//  Created by abuzeid on 10/12/19.
//  Copyright © 2019 abuzeid. All rights reserved.
//

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
