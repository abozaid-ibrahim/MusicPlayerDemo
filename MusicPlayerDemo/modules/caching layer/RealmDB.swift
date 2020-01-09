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
class RealmDb: DataBaseOperations {
    private let config: Realm.Configuration = {
        var config = Realm.Configuration()
        config.fileURL = config.fileURL!.deletingLastPathComponent().appendingPathComponent("MusicDemo.realm")
        return config
    }()

    func printConfigUrl() {
        log(.info, "Realm is located at:", try? Realm(configuration: config).configuration.fileURL ?? "")
    }

    func save(obj: Object) {
        do {
            let realm = try Realm(configuration: config)
            try realm.write {
                realm.add(obj)
            }
            log(.info, "RLM \(obj.classForCoder.className()) is saved open it ")
            printConfigUrl()
        } catch {
            log(.error, error)
        }
    }

    func delete(obj: Object) {
        do {
            let realm = try Realm(configuration: config)
            try realm.write {
                realm.delete(obj)
            }
            log(.info, "RLM  \(obj.description) is deleted ")
        } catch {
            log(.error, error)
        }
    }

    func getAll(of obj: Object.Type) -> [Object] {
        do {
            let realm = try Realm(configuration: config)
            return realm.objects(obj).map { $0 } ?? []
        } catch {
            log(.error, error)
            return []
        }
    }

    func get(obj: Object.Type, filter key: String, value: String) -> Object? {
        do {
            let realm = try Realm(configuration: config)
            return realm.objects(obj).filter("\(key) = '\(value)'").first.map { $0 }
        } catch {
            log(.error, error)
            return nil
        }
    }
}
