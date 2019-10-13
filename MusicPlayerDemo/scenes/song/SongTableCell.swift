//
//  SongTableCell.swift
//  MusicPlayerDemo
//
//  Created by abuzeid on 10/12/19.
//  Copyright © 2019 abuzeid. All rights reserved.
//

import UIKit

final class SongTableCell: UITableViewCell {
    @IBOutlet private var songImgView: UIImageView!
    @IBOutlet private var songNameLbl: UILabel!
    @IBOutlet private var autherLbl: UILabel!
    @IBOutlet private var durationLbl: UILabel!

    func setData(_ icon: String?, name: String?, auther: String?, duration: String?) {
        self.songImgView.setImage(with: icon)
        self.autherLbl.text = auther
        self.songNameLbl.text = name
        self.durationLbl.text = duration
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .blue
        songImgView.circle()
    }
}
