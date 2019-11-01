//
//  DataBaseOperations.swift
//  MusicPlayerDemo
//
//  Created by abuzeid on 11/1/19.
//  Copyright © 2019 abuzeid. All rights reserved.
//

import Foundation
protocol DataBaseOperations {
    associatedtype Cachable
    func save(obj:Cachable)
    func getAll(of obj: Cachable.Type)->[Cachable]
    func delete(obj:Cachable)
}
