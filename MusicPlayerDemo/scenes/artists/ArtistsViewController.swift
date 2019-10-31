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
    var didSelectArtist:Observable<Artist> {
        return subject.asObservable()
    }
        
    var subject: PublishSubject<Artist> = PublishSubject()
    
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
            .bind(to: tableView.rx.items(cellIdentifier: String(describing: ArtistsTableCell.self), cellType: ArtistsTableCell.self)) { _, model, cell in
                cell.setData(with: model)
        }.disposed(by: disposeBag)
        tableView.rx.modelSelected(Artist.self).bind(onNext: showAlbumsOf(artist:)).disposed(by: disposeBag)
        viewModel.error.map { $0.localizedDescription }.bind(to: errorLbl.rx.text).disposed(by: disposeBag)
        viewModel.artistsList.map { $0.count > 0 }.bind(to: errorLbl.rx.isHidden).disposed(by: disposeBag)
    }
    
    private func showAlbumsOf(artist:Artist){
        self.dismiss(animated: true, completion: {
            self.subject.onNext(artist)
        })
        
      
    }
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
        let searchText = (searchController.searchBar.text ?? "")
        viewModel.loadData(showLoader: true, for: searchText)
    }
}
