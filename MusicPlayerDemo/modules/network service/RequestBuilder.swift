//
//  RequestBuilder.swift
//  MusicPlayerDemo
//
//  Created by abuzeid on 10/12/19.
//  Copyright © 2019 abuzeid. All rights reserved.
//

import Foundation

public protocol RequestBuilder {
    var baseURL: URL { get }

    var path: String { get }

    var method: HttpMethod { get }

    var parameters: [String: Any] { get }
    var task: URLRequest { get }
}

extension RequestBuilder {
    var endpoint: URL {
        return URL(string: "\(baseURL)\(path)")!
    }

    var path: String { return "" }
    var task: URLRequest {
        var items = [URLQueryItem]()
        var myURL = URLComponents(string: endpoint.absoluteString)
        for (key, value) in parameters {
            items.append(URLQueryItem(name: key, value: "\(value)"))
        }
        myURL?.queryItems = items
        var request = URLRequest(url: myURL!.url!, cachePolicy: URLRequest.CachePolicy.reloadIgnoringCacheData, timeoutInterval: 30)
        request.httpMethod = method.rawValue
        return request
    }
}

public enum HttpMethod: String {
    case get, post
}

struct APIConstants {
    static let baseURL = "https://ws.audioscrobbler.com/2.0/"
    static let apiKey = "faa9a8a5cdd536094362c2b4da41c2e5"
}
