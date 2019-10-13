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

final class SongsViewController: UIViewController {
    @IBOutlet private var tableView: UITableView!
    private let disposeBag = DisposeBag()

    var viewModel: SongsListViewModel?
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        binding()
    }

    private func configureTableView() {
        tableView.registerNib(SongTableCell.self)
        tableView.seperatorStyle()
    }

    private func binding() {
        viewModel?.artist.filterNil().map { ($0.username ?? "") }.bind(to: rx.title).disposed(by: disposeBag)
        viewModel!.songsList
            .bind(to: tableView.rx.items(cellIdentifier:
                String(describing: SongTableCell.self), cellType: SongTableCell.self)) { _, model, cell in

                cell.setData(model.artworkUrl, name: model.title, auther: model.user?.username, duration: model.duration)
            }.disposed(by: disposeBag)

        tableView.rx.itemSelected.bind(onNext: viewModel!.playSong(index:)).disposed(by: disposeBag)
    }
}
