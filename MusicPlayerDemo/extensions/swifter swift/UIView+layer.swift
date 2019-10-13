//
//  UIView+layer.swift
//  MusicPlayerDemo
//
//  Created by abuzeid on 10/13/19.
//  Copyright © 2019 abuzeid. All rights reserved.
//

import Foundation
import UIKit
extension UIView{
    func circle(){
        self.layer.cornerRadius = min(bounds.height, bounds.width) / 2
        layer.borderColor = UIColor.white.cgColor
        layer.borderWidth = 1.5
        layer.masksToBounds = true
    }
}
