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
    private var subject: PublishSubject<Artist> = PublishSubject()
    private let disposeBag = DisposeBag()
    var viewModel: ArtistsViewModel!
    var didSelectArtist: Observable<Artist> {
        return subject.asObservable()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.registerNib(ArtistsTableCell.self)
        tableView.seperatorStyle()
        bindToViewModel()
    }
}

extension ArtistsViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let searchText = (searchController.searchBar.text ?? "")
        viewModel.textToSearch.onNext(searchText)
    }
}

// MARK: ArtistsViewController (Private)

private extension ArtistsViewController {
    func bindToViewModel() {
        viewModel.showProgress
            .asDriver(onErrorJustReturn: false)
            .drive(onNext: showLoading(show:)).disposed(by: disposeBag)

        viewModel.artistsList
            .asDriver(onErrorJustReturn: [])
            .drive(tableView.rx.items(cellIdentifier: String(describing: ArtistsTableCell.self), cellType: ArtistsTableCell.self)) { _, model, cell in
                cell.setData(with: model)
            }.disposed(by: disposeBag)
        tableView.rx.prefetchRows.bind(onNext: viewModel.loadCells(for:)).disposed(by: disposeBag)
        tableView.rx.modelSelected(Artist.self).bind(onNext: showAlbumsOf(artist:)).disposed(by: disposeBag)
        // handle errors
        viewModel.error.map { $0.localizedDescription }.bind(to: errorLbl.rx.text).disposed(by: disposeBag)
        viewModel.artistsList.map { $0.count > 0 }.bind(to: errorLbl.rx.isHidden).disposed(by: disposeBag)
    }

    func showAlbumsOf(artist: Artist) {
        dismiss(animated: true, completion: {
            self.subject.onNext(artist)
        })
    }
}
