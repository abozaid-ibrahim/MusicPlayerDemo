//
//  ArtistsTableCell.swift
//  MusicPlayerDemo
//
//  Created by abuzeid on 10/12/19.
//  Copyright © 2019 abuzeid. All rights reserved.
//

import UIKit

final class ArtistsTableCell: UITableViewCell {
    @IBOutlet private var artistImgView: UIImageView!
    @IBOutlet private var aristNameLbl: UILabel!
    @IBOutlet private var songsCountLbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        artistImgView.circle()
    }

    func setData(with model: Artist) {
        artistImgView.setImage(with: model.image?.first?.text)
        aristNameLbl.text = model.name
        songsCountLbl.text = model.listeners ?? "" + " fan"
    }
}
