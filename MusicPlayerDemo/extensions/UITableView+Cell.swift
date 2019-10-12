//
//  UITableView+Cell.swift
//  MusicPlayerDemo
//
//  Created by abuzeid on 10/12/19.
//  Copyright © 2019 abuzeid. All rights reserved.
//

import Foundation
import UIKit

extension UITableView{
    func registerNib(_ name:String){
        self.register(UINib(nibName: name, bundle: .none), forCellReuseIdentifier: name)
    }
}
