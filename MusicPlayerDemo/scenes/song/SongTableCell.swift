//
//  SongTableCell.swift
//  MusicPlayerDemo
//
//  Created by abuzeid on 10/12/19.
//  Copyright © 2019 abuzeid. All rights reserved.
//

import UIKit

class SongTableCell: UITableViewCell {
    @IBOutlet private var songImgView: UIImageView!
    @IBOutlet private var songNameLbl: UILabel!
    @IBOutlet private var autherLbl: UILabel!

    func setData(_ icon: String?, name: String?, auther: String?) {
        self.songImgView.setImage(with: icon)
        self.autherLbl.text = auther
        self.songNameLbl.text = name
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
