//
//  SongsApi.swift
//  MusicPlayerDemo
//
//  Created by abuzeid on 10/12/19.
//  Copyright © 2019 abuzeid. All rights reserved.
//

import Foundation

enum SongsApi {
    case feed(type: String, page: Int, count: Int)
}

extension SongsApi: RequestBuilder {
    var baseURL: URL {
        return URL(string: APIConstants.baseURL)!
    }

    var path: String {
        return "feed"
    }

    var endpoint: URL {
        return URL(string: "\(baseURL)\(path)")!
    }

    var method: HttpMethod {
        return .get
    }

    var task: URLRequest {
        switch self {
        case let .feed(prm):
            let prmDic = [
                "type": prm.type,
                "page": prm.page,
                "count": prm.count,
            ] as [String: Any]
            var items = [URLQueryItem]()
            var myURL = URLComponents(string: endpoint.absoluteString)
            for (key, value) in prmDic {
                items.append(URLQueryItem(name: key, value: "\(value)"))
            }
            myURL?.queryItems = items
            var request = URLRequest(url: myURL!.url!, cachePolicy: URLRequest.CachePolicy.reloadIgnoringCacheData, timeoutInterval: 30)
            request.httpMethod = method.rawValue
            return request
        }
    }

    var headers: [String: String]? {
        return ["Content-Type": "application/x-www-form-urlencoded"]
    }
}
