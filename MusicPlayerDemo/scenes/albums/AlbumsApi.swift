//
//  SongsApi.swift
//  MusicPlayerDemo
//
//  Created by abuzeid on 10/12/19.
//  Copyright © 2019 abuzeid. All rights reserved.
//

import Foundation
enum AlbumsApi {
    case albumsFor(artist: String)
    case songs(artist: String?, album: String)
}

extension AlbumsApi: RequestBuilder {
    
    var baseURL: URL {
        return URL(string: APIConstants.baseURL)!
    }
    
    var method: HttpMethod {
        return .get
    }
    var parameters: [String: Any] {
        switch self {
        case let .albumsFor(prm):
            return ["method": "artist.gettopalbums",
                    "api_key": APIConstants.apiKey,
                    "format": "json",
                    "artist": prm]
            
        case let .songs(prm):
            return ["method": "album.getinfo",
                    "api_key": APIConstants.apiKey,
                    "format": "json",
                    "album": prm.album,
                    "artist": prm.artist  ?? ""]
        }
    }
    
}
