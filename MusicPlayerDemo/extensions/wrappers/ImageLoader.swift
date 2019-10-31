//
//  ImageLoader.swift
//  MusicPlayerDemo
//
//  Created by abuzeid on 10/12/19.
//  Copyright © 2019 abuzeid. All rights reserved.
//

import Kingfisher
import UIKit

extension UIImageView {
    /// wrapper for kingfisher setImage
    /// - Parameter url: url of the image
    func setImage(with url: String?) {
        kf.setImage(with: URL(string: url ?? ""))
    }
}
