//
//  AlbumCollectionCell.swift
//  MusicPlayerDemo
//
//  Created by abuzeid on 10/29/19.
//  Copyright © 2019 abuzeid. All rights reserved.
//

import UIKit

final class AlbumCollectionCell: UICollectionViewCell {
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var coverImageView: UIImageView!
    
     func setData(_ model:Album){
        coverImageView.setImage(with: model.image?.first?.text)
        titleLbl.text = model.name
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
