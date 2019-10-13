//
//  FeedViewController.swift
//  MusicPlayerDemo
//
//  Created by abuzeid on 10/12/19.
//  Copyright © 2019 abuzeid. All rights reserved.
//

import RxSwift
import UIKit
final class FeedViewController: UIViewController, Loadable {
    @IBOutlet private var tableView: UITableView!
    private let disposeBag = DisposeBag()
    private var viewModel = FeedListViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.registerNib(FeedTableCell.self)
        tableView.seperatorStyle()
        viewModel.showProgress.bind(onNext: showLoading(show:)).disposed(by: disposeBag)

        viewModel.songsList
            .map { self.viewModel.sortMusicByArtist($0) }
            .bind(to: tableView.rx.items(cellIdentifier: String(describing: FeedTableCell.self),
                                         cellType: FeedTableCell.self)) { _, model, cell in
                cell.setData(with: model)
            }.disposed(by: disposeBag)

        tableView.rx.modelSelected(User.self).bind(onNext: viewModel.songsOf(user:)).disposed(by: disposeBag)
        viewModel.artist.bind(onNext: showSongsList(element:)).disposed(by: disposeBag)
        viewModel.loadData()
    }

    private func showSongsList(element: [FeedResposeElement]) {
        let songsView = SongsViewController()
        let songsViewModel = SongsListViewModel(songs: element)
        songsView.viewModel = songsViewModel
        navigationController?.pushViewController(songsView, animated: true)
    }
}
