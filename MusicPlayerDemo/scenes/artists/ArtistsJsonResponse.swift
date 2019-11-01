//
//  FeedJsonResponse.swift
//  MusicPlayerDemo
//
//  Created by abuzeid on 10/12/19.
//  Copyright © 2019 abuzeid. All rights reserved.
//

import Foundation

// MARK: - Respose

 struct ArtistsSearchRespose: Codable {
     let results: ArtistsSearchResults?
}

// MARK: - Results

 struct ArtistsSearchResults: Codable {
     let opensearchQuery: OpensearchQuery?
     let opensearchTotalResults: String?
     let opensearchStartIndex: String?
     let opensearchItemsPerPage: String?
     let artistmatches: Artistmatches?
     let attr: Attr?

    enum CodingKeys: String, CodingKey {
        case opensearchQuery = "opensearch:Query"
        case opensearchTotalResults = "opensearch:totalResults"
        case opensearchStartIndex = "opensearch:startIndex"
        case opensearchItemsPerPage = "opensearch:itemsPerPage"
        case artistmatches
        case attr = "@attr"
    }

     init(opensearchQuery: OpensearchQuery?, opensearchTotalResults: String?, opensearchStartIndex: String?, opensearchItemsPerPage: String?, artistmatches: Artistmatches?, attr: Attr?) {
        self.opensearchQuery = opensearchQuery
        self.opensearchTotalResults = opensearchTotalResults
        self.opensearchStartIndex = opensearchStartIndex
        self.opensearchItemsPerPage = opensearchItemsPerPage
        self.artistmatches = artistmatches
        self.attr = attr
    }
}

// MARK: - Artistmatches

 struct Artistmatches: Codable {
     let artist: [Artist]?

    enum CodingKeys: String, CodingKey {
        case artist
    }

     init(artist: [Artist]?) {
        self.artist = artist
    }
}

// MARK: - Artist

 struct Artist: Codable {
     let name: String?
     let listeners: String?
     let mbid: String?
     let url: String?
     let streamable: String?
     let image: [Image]?

    enum CodingKeys: String, CodingKey {
        case name
        case listeners
        case mbid
        case url
        case streamable
        case image
    }

     init(name: String?, listeners: String?, mbid: String?, url: String?, streamable: String?, image: [Image]?) {
        self.name = name
        self.listeners = listeners
        self.mbid = mbid
        self.url = url
        self.streamable = streamable
        self.image = image
    }
}

// MARK: - Image



 enum Size: String, Codable {
    case extralarge
    case large
    case medium
    case mega
    case small
}

// MARK: - Attr

 struct Attr: Codable {
     let attrFor: String?

    enum CodingKeys: String, CodingKey {
        case attrFor = "for"
    }

     init(attrFor: String?) {
        self.attrFor = attrFor
    }
}

// MARK: - OpensearchQuery

 struct OpensearchQuery: Codable {
     let text: String?
     let role: String?
     let searchTerms: String?
     let startPage: String?

    enum CodingKeys: String, CodingKey {
        case text = "#text"
        case role
        case searchTerms
        case startPage
    }

     init(text: String?, role: String?, searchTerms: String?, startPage: String?) {
        self.text = text
        self.role = role
        self.searchTerms = searchTerms
        self.startPage = startPage
    }
}
