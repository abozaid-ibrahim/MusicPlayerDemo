//
//  SongsApi.swift
//  MusicPlayerDemo
//
//  Created by abuzeid on 10/12/19.
//  Copyright © 2019 abuzeid. All rights reserved.
//

import Foundation

enum ArtistsApi {
    case searchFor(artist: String, page: Int, count: Int)
}

extension ArtistsApi: RequestBuilder {
    var parameters: [String : String] {
        switch self {
        case .searchFor(let prm):
            return [
                "method": "artist.search",
                "api_key": APIConstants.apiKey,
                "format": "json",
                "artist": prm.artist
            ]
        }
    }
    
    
    var baseURL: URL {
        return URL(string: APIConstants.baseURL)!
    }
    var method: HttpMethod {
        return .get
    }
    
    
}
