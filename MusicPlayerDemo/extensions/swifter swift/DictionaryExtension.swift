//
//  DictionaryExtension.swift
//  MusicPlayerDemo
//
//  Created by abuzeid on 10/31/19.
//  Copyright © 2019 abuzeid. All rights reserved.
//

import Foundation
extension Dictionary {
    mutating func merge(dict: [Key: Value]) {
        for (k, v) in dict {
            updateValue(v, forKey: k)
        }
    }
}

extension Optional where Wrapped == String {
    var toInt: Int {
        return Int(self ?? "0") ?? 0
    }
}
