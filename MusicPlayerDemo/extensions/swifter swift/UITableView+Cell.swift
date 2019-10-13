//
//  UITableView+Cell.swift
//  MusicPlayerDemo
//
//  Created by abuzeid on 10/12/19.
//  Copyright © 2019 abuzeid. All rights reserved.
//

import Foundation
import UIKit

extension UITableView {
    func registerNib(_ name: UITableViewCell.Type) {
        self.register(UINib(nibName: String(describing: name.self), bundle: .none),
                      forCellReuseIdentifier: String(describing: name.self))
    }
    func seperatorStyle(){
        self.separatorStyle = .none
        self.tableFooterView = UIView()
    }
}
