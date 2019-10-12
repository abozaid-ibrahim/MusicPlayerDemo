//
//  UIView+Constrains.swift
//  MusicPlayerDemo
//
//  Created by abuzeid on 10/12/19.
//  Copyright © 2019 abuzeid. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    func equalToSuperViewEdges(insets: UIEdgeInsets = .zero) {
        guard let parent = self.superview else {
            return
        }
        self.translatesAutoresizingMaskIntoConstraints = false
        self.leadingAnchor.constraint(equalTo: parent.leadingAnchor, constant: insets.left).isActive = true
        self.trailingAnchor.constraint(equalTo: parent.trailingAnchor, constant: insets.right).isActive = true
        self.topAnchor.constraint(equalTo: parent.topAnchor, constant: insets.top).isActive = true
        self.bottomAnchor.constraint(equalTo: parent.bottomAnchor, constant: insets.bottom).isActive = true
    }
}
