//
//  DataBaseOperations.swift
//  MusicPlayerDemo
//
//  Created by abuzeid on 11/1/19.
//  Copyright © 2019 abuzeid. All rights reserved.
//

import Foundation
protocol DataBaseOperations {
    associatedtype Object
    func save(obj:Object)
    func getAll()->[Object]
    func delete(obj:Object)
}
