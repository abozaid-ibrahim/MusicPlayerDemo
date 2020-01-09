//
//  Alamfore+callbacks.swift
//  MusicPlayerDemo
//
//  Created by Abuzeid on 1/9/20.
//  Copyright © 2020 abuzeid. All rights reserved.
//

import Foundation
extension AlamofireClient {
    func getData(of api: RequestBuilder, completion: @escaping (Result<Data, Error>) -> Void) {
        excute(api)
            .subscribe(onNext: { value in
                guard let data = value else {
                    completion(.failure(NetworkFailure.generalFailure))
                    return
                }
                completion(.success(data))

            }, onError: { err in
                completion(.failure(err))
            }).disposed(by: disposeBag)
    }
}
