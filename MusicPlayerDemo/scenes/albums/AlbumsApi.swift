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
    case songs(artist:String?,album:String)
}

extension AlbumsApi: RequestBuilder {
    var parameters: [String : Any] {
        switch self {
        case .albumsFor(let prm):
            return [
                "method": "artist.gettopalbums",
                "api_key": APIConstants.apiKey,
                "format": "json",
                "artist": prm
            ]
            
            
        case .songs(let prm):
            return [
                "method": "album.getinfo",
                "api_key": APIConstants.apiKey,
                "format": "json",
                "album": prm.album
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
