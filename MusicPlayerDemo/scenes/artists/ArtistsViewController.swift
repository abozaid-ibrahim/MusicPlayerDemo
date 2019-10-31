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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.registerNib(ArtistsTableCell.self)
        tableView.seperatorStyle()
        bindToViewModel()
    }
    
    private func bindToViewModel() {
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
        viewModel.error.map { $0.localizedDescription }.bind(to: errorLbl.rx.text).disposed(by: disposeBag)
        viewModel.artistsList.map { $0.count > 0 }.bind(to: errorLbl.rx.isHidden).disposed(by: disposeBag)
    }
    
    private func showAlbumsOf(artist:Artist){
        self.dismiss(animated: true, completion: {
            self.subject.onNext(artist)
        })
    }
    var didSelectArtist:Observable<Artist> {
        return subject.asObservable()
    }
    
    
}


extension ArtistsViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let searchText = (searchController.searchBar.text ?? "")
//        viewModel.loadData(showLoader: true, for: searchText)
        viewModel.textToSearch.onNext(searchText)
    }
}
