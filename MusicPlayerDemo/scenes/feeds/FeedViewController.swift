//
//  FeedViewController.swift
//  MusicPlayerDemo
//
//  Created by abuzeid on 10/12/19.
//  Copyright © 2019 abuzeid. All rights reserved.
//

import RxSwift
import UIKit
final class FeedViewController: UIViewController {
    @IBOutlet private var tableView: UITableView!
    private let disposeBag = DisposeBag()
    private var viewModel = FeedListViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.registerNib(FeedTableCell.self)

        viewModel.feedsList
            .bind(to: tableView.rx.items(cellIdentifier: String(describing: FeedTableCell.self),
                                         cellType: FeedTableCell.self)) { _, model, cell in

                cell.setData(with: model)
            }.disposed(by: disposeBag)

        tableView.rx.modelSelected(User.self).subscribe(onNext: { [unowned self] value in
            self.showSongsList(element: self.viewModel.songsOf(user: value))

        }).disposed(by: disposeBag)
    }

    private func showSongsList(element: Observable<[FeedResposeElement]>) {
        let songsView = SongsViewController()
        let songsViewModel = SongsListViewModel(player: AudioPlayer(), songs: element)
        songsView.viewModel = songsViewModel
        addChild(songsView)
        view.addSubview(songsView.view)
    }
}

