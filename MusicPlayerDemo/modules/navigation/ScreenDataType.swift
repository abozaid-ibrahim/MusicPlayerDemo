//
//  ScreenDataType.swift
//  MusicPlayerDemo
//
//  Created by abuzeid on 11/2/19.
//  Copyright © 2019 abuzeid. All rights reserved.
//

import Foundation

enum ScreenDataType:Equatable {
    case offline, online
    static public func ==(lhs: ScreenDataType, rhs: ScreenDataType) -> Bool {
        switch (lhs, rhs) {
        case (.offline, .offline),
             (.online, .online):
            return true
        default:
            return false
        }
    }
}
