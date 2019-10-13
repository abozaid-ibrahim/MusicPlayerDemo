//
//  FeedViewController.swift
//  MusicPlayerDemo
//
//  Created by abuzeid on 10/12/19.
//  Copyright © 2019 abuzeid. All rights reserved.
//

import RxSwift
import UIKit

/// list of artists
final class FeedViewController: UIViewController, Loadable {
    @IBOutlet private var tableView: UITableView!
    private let disposeBag = DisposeBag()
    private var viewModel = FeedListViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.registerNib(FeedTableCell.self)
        tableView.seperatorStyle()
        viewModel.showProgress
            .observeOn(MainScheduler.instance)
            .bind(onNext: showLoading(show:)).disposed(by: disposeBag)

        viewModel.songsList
            .map { self.viewModel.sortMusicByArtist($0) }
            .bind(to: tableView.rx.items(cellIdentifier: String(describing: FeedTableCell.self),
                                         cellType: FeedTableCell.self)) { _, model, cell in
                cell.setData(with: model)
            }.disposed(by: disposeBag)

        tableView.rx.modelSelected(Artist.self).bind(onNext: viewModel.songsOf(user:)).disposed(by: disposeBag)
        viewModel.artist.bind(onNext: showSongsList(element:)).disposed(by: disposeBag)
        viewModel.loadData()
    }
    
    /// show list of songs for spacific arist
    /// - Parameter element: list of songs for the artist
    private func showSongsList(element: [SongEntity]) {
        let songsView = SongsViewController()
        let songsViewModel = SongsListViewModel(songs: element)
        songsView.viewModel = songsViewModel
        navigationController?.pushViewController(songsView, animated: true)
    }
}
