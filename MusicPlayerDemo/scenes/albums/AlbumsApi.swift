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
    var baseURL: URL {
        return URL(string: APIConstants.baseURL)!
    }
    
    var path: String {
        return ""
    }
    var method: HttpMethod {
        return .get
    }
    
    var task: URLRequest {
        switch self {
        case .albumsFor(let prm):
            let prmDic = [
                "method": "artist.gettopalbums",
                "api_key": APIConstants.apiKey,
                "format": "json",
                "artist": prm
                ] as [String: Any]
            var items = [URLQueryItem]()
            var myURL = URLComponents(string: endpoint.absoluteString)
            for (key, value) in prmDic {
                items.append(URLQueryItem(name: key, value: "\(value)"))
            }
            myURL?.queryItems = items
            let request = URLRequest(url: myURL!.url!, cachePolicy: URLRequest.CachePolicy.reloadIgnoringCacheData, timeoutInterval: 30)
            //            request.httpMethod = method.rawValue
            log(.info,prmDic)
            return request
        case .songs(let prm):
            var prmDic = [
                "method": "album.getinfo",
                "api_key": APIConstants.apiKey,
                "format": "json",
                "album": prm.album
                ] as [String: Any]
            if let artist = prm.artist{
                prmDic.merge(dict: [ "artist": artist])
            }
            var items = [URLQueryItem]()
            var myURL = URLComponents(string: endpoint.absoluteString)
            for (key, value) in prmDic {
                items.append(URLQueryItem(name: key, value: "\(value)"))
            }
            myURL?.queryItems = items
            return URLRequest(url: myURL!.url!, cachePolicy: URLRequest.CachePolicy.reloadIgnoringCacheData, timeoutInterval: 30)
            
            
            
        }
    }
}
