//
//  FeedJsonResponse.swift
//  MusicPlayerDemo
//
//  Created by abuzeid on 10/12/19.
//  Copyright © 2019 abuzeid. All rights reserved.
//

import Foundation

// MARK: - Respose

public struct ArtistsSearchRespose: Codable {
    public let results: ArtistsSearchResults?
}

// MARK: - Results

public struct ArtistsSearchResults: Codable {
    public let opensearchQuery: OpensearchQuery?
    public let opensearchTotalResults: String?
    public let opensearchStartIndex: String?
    public let opensearchItemsPerPage: String?
    public let artistmatches: Artistmatches?
    public let attr: Attr?

    enum CodingKeys: String, CodingKey {
        case opensearchQuery = "opensearch:Query"
        case opensearchTotalResults = "opensearch:totalResults"
        case opensearchStartIndex = "opensearch:startIndex"
        case opensearchItemsPerPage = "opensearch:itemsPerPage"
        case artistmatches
        case attr = "@attr"
    }

    public init(opensearchQuery: OpensearchQuery?, opensearchTotalResults: String?, opensearchStartIndex: String?, opensearchItemsPerPage: String?, artistmatches: Artistmatches?, attr: Attr?) {
        self.opensearchQuery = opensearchQuery
        self.opensearchTotalResults = opensearchTotalResults
        self.opensearchStartIndex = opensearchStartIndex
        self.opensearchItemsPerPage = opensearchItemsPerPage
        self.artistmatches = artistmatches
        self.attr = attr
    }
}

// MARK: - Artistmatches

public struct Artistmatches: Codable {
    public let artist: [Artist]?

    enum CodingKeys: String, CodingKey {
        case artist
    }

    public init(artist: [Artist]?) {
        self.artist = artist
    }
}

// MARK: - Artist

public struct Artist: Codable {
    public let name: String?
    public let listeners: String?
    public let mbid: String?
    public let url: String?
    public let streamable: String?
    public let image: [Image]?

    enum CodingKeys: String, CodingKey {
        case name
        case listeners
        case mbid
        case url
        case streamable
        case image
    }

    public init(name: String?, listeners: String?, mbid: String?, url: String?, streamable: String?, image: [Image]?) {
        self.name = name
        self.listeners = listeners
        self.mbid = mbid
        self.url = url
        self.streamable = streamable
        self.image = image
    }
}

// MARK: - Image

public struct Image: Codable {
    public let text: String?
    public let size: Size?

    enum CodingKeys: String, CodingKey {
        case text = "#text"
        case size
    }

    public init(text: String?, size: Size?) {
        self.text = text
        self.size = size
    }
}

public enum Size: String, Codable {
    case extralarge
    case large
    case medium
    case mega
    case small
}

// MARK: - Attr

public struct Attr: Codable {
    public let attrFor: String?

    enum CodingKeys: String, CodingKey {
        case attrFor = "for"
    }

    public init(attrFor: String?) {
        self.attrFor = attrFor
    }
}

// MARK: - OpensearchQuery

public struct OpensearchQuery: Codable {
    public let text: String?
    public let role: String?
    public let searchTerms: String?
    public let startPage: String?

    enum CodingKeys: String, CodingKey {
        case text = "#text"
        case role
        case searchTerms
        case startPage
    }

    public init(text: String?, role: String?, searchTerms: String?, startPage: String?) {
        self.text = text
        self.role = role
        self.searchTerms = searchTerms
        self.startPage = startPage
    }
}
