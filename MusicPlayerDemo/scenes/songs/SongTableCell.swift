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
    func setData(_ model: Track) {
        self.songImgView.setImage(with: model.image?.first?.text)
        self.autherLbl.text = model.artist?.name
        self.songNameLbl.text = model.name
        self.durationLbl.text = model.duration
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .blue
        songImgView.circle()
    }
}
