//
//  APIClient.swift
//  MusicPlayerDemo
//
//  Created by abuzeid on 10/12/19.
//  Copyright © 2019 abuzeid. All rights reserved.
//

import Foundation
import RxOptional
import RxSwift
protocol ApiClient {
    func getData(of request: RequestBuilder) -> Observable<SongsList?>
    
}

/// api handler, wrapper for the Url session
final class HTTPClient: ApiClient {
    private let disposeBag = DisposeBag()
    func getData(of request: RequestBuilder) -> Observable<SongsList?> {
        log(.info,"\(request)")
        return excute(request).map { $0?.toModel() }.filterNil()
    }

    /// fire the http request and return observable of the data or emit an error
    /// - Parameter request: the request that have all the details that need to call the remote api
    private func excute(_ request: RequestBuilder) -> Observable<Data?> {
        return Observable<Data?>.create { (observer) -> Disposable in
            let task = URLSession.shared.dataTask(with: request.task) { data, response, error in
                if let error = error {
                    observer.onError(error)
                    return
                }
                guard let httpResponse = response as? HTTPURLResponse,
                    (200 ... 299).contains(httpResponse.statusCode) else {
                    observer.onError(NetworkFailure.generalFailure)
                    return
                }
                print(String(data: data!, encoding: .utf8) ?? "")
                observer.onNext(data)
            }
            task.resume()
            return Disposables.create()
        }
        .share(replay: 0, scope: .forever)
    }
}
