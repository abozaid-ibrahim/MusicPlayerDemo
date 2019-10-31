//
//  ArtistsViewController.swift
//  MusicPlayerDemo
//
//  Created by abuzeid on 10/12/19.
//  Copyright © 2019 abuzeid. All rights reserved.
//

import RxSwift
import UIKit

/// list of artists
final class ArtistsViewController: UIViewController, Loadable {
    @IBOutlet private var tableView: UITableView!
    @IBOutlet private var errorLbl: UILabel!

    private let disposeBag = DisposeBag()
    var viewModel: ArtistsViewModel!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.registerNib(ArtistsTableCell.self)
        tableView.seperatorStyle()
        bindToViewModel()
        viewModel.loadData(showLoader: true)
    }

    /// bind views to viewmodel attributes
    private func bindToViewModel() {
        viewModel.showProgress
            .asDriver(onErrorJustReturn: false)
            .drive(onNext: showLoading(show:)).disposed(by: disposeBag)
        viewModel.artistsList
            .asDriver(onErrorJustReturn: [])
            .drive(tableView.rx.items(cellIdentifier: String(describing: ArtistsTableCell.self), cellType: ArtistsTableCell.self)) { _, model, cell in
                cell.setData(with: model)
            }.disposed(by: disposeBag)
       tableView.rx.prefetchRows.bind(onNext: viewModel.loadMoreCells(prefetchRowsAt:)).disposed(by: disposeBag)

        tableView.rx.modelSelected(Artist.self).bind(onNext: viewModel.songsOf(user:)).disposed(by: disposeBag)
        viewModel.artistSongsList.bind(onNext: showSongsList(element:)).disposed(by: disposeBag)

        viewModel.error.map { $0.localizedDescription }.bind(to: errorLbl.rx.text).disposed(by: disposeBag)
        viewModel.artistsList.map { $0.count > 0 }.bind(to: errorLbl.rx.isHidden).disposed(by: disposeBag)
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
