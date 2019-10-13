//
//  SongsViewController.swift
//  MusicPlayerDemo
//
//  Created by abuzeid on 10/12/19.
//  Copyright © 2019 abuzeid. All rights reserved.
//

import RxCocoa
import RxOptional
import RxSwift
import UIKit

class SongsViewController: UIViewController {
    @IBOutlet private var tableView: UITableView!
    private let disposeBag = DisposeBag()

    var viewModel: SongsListViewModel?
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.registerNib(SongTableCell.self)

        viewModel!.songsList.debug("sooongs", trimOutput: false)
            .bind(to: tableView.rx.items(cellIdentifier:
                String(describing: SongTableCell.self), cellType: SongTableCell.self)) { _, model, cell in

                cell.setData(model.artworkUrl, name: model.title, auther: model.user?.username)
            }.disposed(by: disposeBag)

        viewModel?.playSong(action: tableView.rx.itemSelected.asObservable())
    }
}
