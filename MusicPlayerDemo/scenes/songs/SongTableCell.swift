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

    @IBOutlet private var songNameLbl: UILabel!
    @IBOutlet private var durationLbl: UILabel!

    func setData(_ model: Track) {
        songNameLbl.text = model.name
        durationLbl.text = (model.duration ?? "0").songDurationFormat
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .blue
    }
}
