//
//  RealmDB.swift
//  MusicPlayerDemo
//
//  Created by abuzeid on 11/1/19.
//  Copyright © 2019 abuzeid. All rights reserved.
//

import Foundation
import RealmSwift
import Realm
class RealmDb: DataBaseOperations {
    typealias Cachable = Object
    lazy var realm = try? Realm()
    func printConfigUrl(){
        log(.info,"Realm is located at:", realm?.configuration.fileURL ?? "")
    }
    func save(obj: Object) {
        DispatchQueue(label: "background").async {
            autoreleasepool {
                try! self.realm?.write {
                    self.realm?.add(obj)
                }
            }
        }
    }
    
    func delete(obj: Object) {
        try? realm?.write {
            realm?.delete(obj)
        }
    }
    func getAll(of obj: Object.Type) -> [Object] {
        return realm?.objects(obj).map{$0} ?? []
    }
    func get(obj: Object.Type,filter key:String,value:String) -> Object? {
        return realm?.objects(obj).filter("\(key) == \(value)").first.map{$0}
    }
    
    
}
