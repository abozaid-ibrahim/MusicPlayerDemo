//
//  SongTableCell.swift
//  MusicPlayerDemo
//
//  Created by abuzeid on 10/12/19.
//  Copyright © 2019 abuzeid. All rights reserved.
//

import UIKit

final class SongTableCell: UITableViewCell {
    // MARK: Outlets

    @IBOutlet private var songImgView: UIImageView!
    @IBOutlet private var songNameLbl: UILabel!
    @IBOutlet private var autherLbl: UILabel!
    @IBOutlet private var durationLbl: UILabel!

    /// fill ui with it's model
    /// - Parameter icon: song artwork
    /// - Parameter name: song title
    /// - Parameter auther: auther name
    /// - Parameter duration: duration of the song
    func setData(_ icon: String?, name: String?, auther: String?, duration: String?) {
        songImgView.setImage(with: icon)
        autherLbl.text = auther
        songNameLbl.text = name
        durationLbl.text = duration
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .blue
        songImgView.circle()
    }
}
