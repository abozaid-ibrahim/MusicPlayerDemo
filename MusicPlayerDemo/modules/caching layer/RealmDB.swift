//
//  RealmDB.swift
//  MusicPlayerDemo
//
//  Created by abuzeid on 11/1/19.
//  Copyright © 2019 abuzeid. All rights reserved.
//

import Foundation
import Realm
import RealmSwift
final class RealmDb: DataBaseOperations {
    typealias Cachable = Object
    private let config:Realm.Configuration = {
        var config = Realm.Configuration()
        config.fileURL = config.fileURL!.deletingLastPathComponent()
            .appendingPathComponent("MusicDemo.realm")
        return config
    }()
    func printConfigUrl() {
        log(.info, "Realm is located at:", try? Realm(configuration: config).configuration.fileURL ?? "")
    }
    
    func save(obj: Object) {
        autoreleasepool {
            let realm = try? Realm(configuration: config)
            try? realm?.write {
                realm?.add(obj)
            }
            log(.info, "RLM \(obj.classForCoder.className()) is saved open it ")
            self.printConfigUrl()
        }
        
    }
    
    func delete(obj: Object) {
        let realm = try? Realm(configuration: config)
        try? realm?.write {
            realm?.delete(obj)
        }
        log(.info, "RLM  \(obj.description) is deleted ")
    }
    
    func getAll(of obj: Object.Type) -> [Object] {
        let realm = try? Realm(configuration: config)
        return realm?.objects(obj).map { $0 } ?? []
    }
    
    func get(obj: Object.Type, filter key: String, value: String) -> Object? {
        let realm = try? Realm(configuration: config)
        return realm?.objects(obj).filter("\(key) = '\(value)'").first.map { $0 }
    }
}

