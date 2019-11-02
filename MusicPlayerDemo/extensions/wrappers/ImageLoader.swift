//
//  ImageLoader.swift
//  MusicPlayerDemo
//
//  Created by abuzeid on 10/12/19.
//  Copyright © 2019 abuzeid. All rights reserved.
//

import Alamofire
import AlamofireImage
import UIKit

extension UIImageView {
    /// wrapper for kingfisher setImage
    /// - Parameter url: url of the image
    func setImage(with url: String?) {
        guard let url = url else{return}
        Alamofire.request(url).responseImage {[weak self] response in
            if let image = response.result.value {
                self?.image = image
            }
        }

    }
}
