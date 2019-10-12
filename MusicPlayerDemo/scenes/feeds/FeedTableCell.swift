//
//  FeedTableCell.swift
//  MusicPlayerDemo
//
//  Created by abuzeid on 10/12/19.
//  Copyright © 2019 abuzeid. All rights reserved.
//

import UIKit

class FeedTableCell: UITableViewCell {

    @IBOutlet weak var artistImgView: UIImageView!
    @IBOutlet weak var aristNameLbl: UILabel!
    @IBOutlet weak var songsCountLbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        artistImgView.layer.cornerRadius = 12
        artistImgView.layer.borderColor = UIColor.darkGray.cgColor
        artistImgView.layer.borderWidth = 1
    }
    func setData(with model:User){
        artistImgView.setImage(with: model.avatarUrl)
        aristNameLbl.text = model.username
        songsCountLbl.text = String(model.songsCount)
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
