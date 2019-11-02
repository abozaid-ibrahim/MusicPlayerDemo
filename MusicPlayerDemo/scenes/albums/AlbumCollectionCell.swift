//
//  AlbumCollectionCell.swift
//  MusicPlayerDemo
//
//  Created by abuzeid on 10/29/19.
//  Copyright © 2019 abuzeid. All rights reserved.
//

import RxSwift
import UIKit

final class AlbumCollectionCell: UICollectionViewCell {
    @IBOutlet private var titleLbl: UILabel!
    @IBOutlet private var coverImageView: UIImageView!
    private(set) var disposeBag = DisposeBag()
    
    func setData(_ model: Album) {
        coverImageView.setImage(with: model.image?.first?.text)
        titleLbl.text = model.name
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
}
