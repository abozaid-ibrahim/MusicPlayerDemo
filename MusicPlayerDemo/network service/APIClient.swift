//
//  APIClient.swift
//  MusicPlayerDemo
//
//  Created by abuzeid on 10/12/19.
//  Copyright © 2019 abuzeid. All rights reserved.
//

import Foundation
import RxSwift
import RxOptional

class HTTPClient {
    private let disposeBag = DisposeBag()
    func getData(of request: RequestBuilder) -> Observable<ArtistsRespose?> {
        return excute(request).map {$0?.toModel() }.filterNil()
    }

    private func excute(_ request: RequestBuilder) -> Observable<Data?> {
        return Observable<Data?>.create { (observer) -> Disposable in

            let task = URLSession.shared.dataTask(with: request.task) { [weak self] data, response, error in

                if let error = error {
                    print(error)
                    return
                }
                guard let httpResponse = response as? HTTPURLResponse,
                    (200...299).contains(httpResponse.statusCode) else {
                    print(response)
                    /// self.handleServerError(response)
                    return
                }
                observer.onNext(data)
            }

            task.resume()
            return Disposables.create()
        }
        .share(replay: 0, scope: .whileConnected)
    }
}

extension Data {
    func toModel<T: Decodable>() -> T? {
        do {
            let object = try JSONDecoder().decode(T.self, from: self)
            return object
        } catch {
            print(">>> parsing error \(error)")
            return nil
        }
    }
}

enum NetworkFailure: Error {
    case generalFailure, failedToParseData
}
