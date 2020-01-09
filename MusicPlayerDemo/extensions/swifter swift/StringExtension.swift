//
//  StringExtesnion.swift
//  MusicPlayerDemo
//
//  Created by Abuzeid on 1/9/20.
//  Copyright © 2020 abuzeid. All rights reserved.
//

import Foundation
extension String {
    /// convert string to formated duration
    var songDurationFormat: String {
        guard let seconds = Int(self) else {
            return String(format: "%02d:%02d",  0, 0)
        }
        return String(format: "%02d:%02d",  (seconds % 3600) / 60, (seconds % 3600) % 60)
    }
}
