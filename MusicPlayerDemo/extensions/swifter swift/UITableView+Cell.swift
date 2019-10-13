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
    
    /// wrapper to register cell in a short line
    /// - Parameter name: the cell identifier
    func registerNib(_ name: UITableViewCell.Type) {
        self.register(UINib(nibName: String(describing: name.self), bundle: .none),
                      forCellReuseIdentifier: String(describing: name.self))
    }
    
    /// set the cell seperator style and remove it from the empty cells
    func seperatorStyle(){
        self.separatorStyle = .none
        self.tableFooterView = UIView()
    }
}
