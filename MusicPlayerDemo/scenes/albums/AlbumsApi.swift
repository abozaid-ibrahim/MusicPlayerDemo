//
//  SongsApi.swift
//  MusicPlayerDemo
//
//  Created by abuzeid on 10/12/19.
//  Copyright © 2019 abuzeid. All rights reserved.
//

import Foundation

enum AlbumsApi {
    case albumsFor(artist: String, page: Int, count: Int)
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
                "artist": prm.artist,
                "page": prm.page,
                "count": prm.count
            ] as [String: Any]
            var items = [URLQueryItem]()
            var myURL = URLComponents(string: endpoint.absoluteString)
            for (key, value) in prmDic {
                items.append(URLQueryItem(name: key, value: "\(value)"))
            }
            myURL?.queryItems = items
            let request = URLRequest(url: myURL!.url!, cachePolicy: URLRequest.CachePolicy.reloadIgnoringCacheData, timeoutInterval: 30)
//            request.httpMethod = method.rawValue
            return request
        }
    }
}
