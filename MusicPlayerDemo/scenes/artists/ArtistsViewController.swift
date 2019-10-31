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
        tableView.rx.prefetchRows.bind(onNext: viewModel.loadPages(for:)).disposed(by: disposeBag)
        bindToViewModel()
    }

    /// bind views to viewmodel attributes
    private func bindToViewModel() {
        viewModel.showProgress
            .observeOn(MainScheduler.instance)
            .bind(onNext: showLoading(show:)).disposed(by: disposeBag)
        viewModel.artistsList
            .observeOn(MainScheduler.instance)
            .debug("artists>>>", trimOutput: true)
            .bind(to: tableView.rx.items(cellIdentifier: String(describing: ArtistsTableCell.self), cellType: ArtistsTableCell.self)) { _, model, cell in
                cell.setData(with: model)
            }.disposed(by: disposeBag)
        tableView.rx.modelSelected(Artist.self).bind(onNext: songsOf(user:)).disposed(by: disposeBag)
//                viewModel.artistSongsList.bind(onNext: showSongsList(element:)).disposed(by: disposeBag)
        viewModel.error.map { $0.localizedDescription }.bind(to: errorLbl.rx.text).disposed(by: disposeBag)
        viewModel.artistsList.map { $0.count > 0 }.bind(to: errorLbl.rx.isHidden).disposed(by: disposeBag)
    }
    func songsOf(user: Artist) {
        (self.parent as? UISearchController)?.isActive = false
        AlbumsCoordinator(self.navigationController).start(completion: nil, for: user)
    }


    /// show list of songs for spacific arist
    /// - Parameter element: list of songs for the artist
    //    private func showSongsList(element: [SongEntity]) {
    //        let songsView = SongsViewController()
    //        let songsViewModel = SongsListViewModel(songs: element)
    //        songsView.viewModel = songsViewModel
    //        navigationController?.pushViewController(songsView, animated: true)
    //    }
}

// MARK: - UITableViewDataSourcePrefetching

extension ArtistsViewController: UITableViewDataSourcePrefetching {
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        if indexPaths.contains(where: isLoadingCell) {
            //            viewModel.loadData(showLoader: false)
        }
    }

    func isLoadingCell(for indexPath: IndexPath) -> Bool {
        return indexPath.row >= viewModel.currentCount
    }
}

extension ArtistsViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        print("Searching with: " + (searchController.searchBar.text ?? ""))
        let searchText = (searchController.searchBar.text ?? "")
        viewModel.loadData(showLoader: true, for: searchText)
    }
}
