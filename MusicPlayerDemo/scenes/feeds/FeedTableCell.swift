//
//  FeedTableCell.swift
//  MusicPlayerDemo
//
//  Created by abuzeid on 10/12/19.
//  Copyright © 2019 abuzeid. All rights reserved.
//

import UIKit

class FeedTableCell: UITableViewCell {
    @IBOutlet var artistImgView: UIImageView!
    @IBOutlet var aristNameLbl: UILabel!
    @IBOutlet var songsCountLbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        artistImgView.circle()
    }

    func setData(with model: User) {
        artistImgView.setImage(with: model.avatarUrl)
        aristNameLbl.text = model.username
        songsCountLbl.text = String(model.songsCount)
    }
}
