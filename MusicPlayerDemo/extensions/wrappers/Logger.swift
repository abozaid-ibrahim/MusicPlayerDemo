//
//  Logger.swift
//  MusicPlayerDemo
//
//  Created by abuzeid on 10/31/19.
//  Copyright © 2019 abuzeid. All rights reserved.
//

import Foundation
enum LoggingLevels {
    case info, error
    var value: String {
        switch self {
        case .info:
            return "INFO>"
        case .error:
            return "ERROR>"
        }
    }
}

func log(_ level: LoggingLevels, _ value: Any?...) {
    #if DEBUG
        print("->\(level.value) \(value)")
    #endif
}
