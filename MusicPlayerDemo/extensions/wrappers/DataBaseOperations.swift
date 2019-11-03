//
//  DataBaseOperations.swift
//  MusicPlayerDemo
//
//  Created by abuzeid on 11/1/19.
//  Copyright © 2019 abuzeid. All rights reserved.
//

import Foundation
import RealmSwift
import Realm
typealias Cachable = Object
protocol DataBaseOperations {
    func save(obj: Cachable)
    func getAll(of obj: Cachable.Type) -> [Cachable]
    func delete(obj: Cachable)
    func get(obj: Cachable.Type, filter key: String, value: String) -> Cachable?
}

