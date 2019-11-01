//
//  AlbumCollectionCell.swift
//  MusicPlayerDemo
//
//  Created by abuzeid on 10/29/19.
//  Copyright © 2019 abuzeid. All rights reserved.
//

import UIKit
import RxSwift

final class AlbumCollectionCell: UICollectionViewCell {
    @IBOutlet private weak var titleLbl: UILabel!
    @IBOutlet private weak var coverImageView: UIImageView!
    @IBOutlet private weak var offlineAlbums: UIImageView!
    private(set) var disposeBag = DisposeBag()
    
    var onClickOffline :Observable<UITapGestureRecognizer>{
        return offlineAlbums.rx.tapGesture().asObservable()
    }
    func setData(_ model:Album){
        coverImageView.setImage(with: model.image?.first?.text)
        titleLbl.text = model.name
        
        
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
}
