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
final class AlbumsViewController: UIViewController, Loadable {
    @IBOutlet private var albumsCollectionView: UICollectionView!

    @IBOutlet private var errorLbl: UILabel!
    private let disposeBag = DisposeBag()
    var viewModel: AlbumsViewModel!
    override func viewDidLoad() {
        super.viewDidLoad()
        albumsCollectionView.register(UINib(nibName: cellId, bundle: .none), forCellWithReuseIdentifier: cellId)
        bindToViewModel()
        viewModel.loadData(showLoader: true)
        self.addSearchToNavigationBar()
    }

    private lazy var results: ArtistsViewController = {
        print("GET REsutl>>>>")
        let artistsController = ArtistsViewController()
        artistsController.title = "Your Albums"
        artistsController.viewModel = ArtistsListViewModel()
        return artistsController
    }()
    private func addSearchToNavigationBar() {
//        let searchBtn = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(search))
//        navigationItem.leftBarButtonItem = searchBtn
        let searchController = UISearchController(searchResultsController: results)
        searchController.searchResultsUpdater = results
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search artists"
        self.navigationItem.searchController = searchController
        self.definesPresentationContext = true
//ios10
        navigationItem.titleView = searchController.searchBar;

        
    }

    @objc private func search(_ text: String){
        let results = (0...100).map{"\($0)"}
    }
    private var cellId: String {
        return String(describing: AlbumCollectionCell.self)
    }

    private func bindToViewModel() {
        viewModel.showProgress
            .asDriver(onErrorJustReturn: false)
            .drive(onNext: showLoading(show:)).disposed(by: disposeBag)

        viewModel.artistsList
            .bind(to: albumsCollectionView.rx.items(cellIdentifier: cellId, cellType: AlbumCollectionCell.self)) { index, _, cell in
                cell.setData("\(index)")
            }.disposed(by: disposeBag)

        // add this line you can provide the cell size from delegate method
        albumsCollectionView.rx.setDelegate(self).disposed(by: disposeBag)

        albumsCollectionView.rx.modelSelected(Artist.self).bind(onNext: viewModel.songsOf(user:)).disposed(by: disposeBag)
//        viewModel.artistSongsList.bind(onNext: showSongsList(element:)).disposed(by: disposeBag)
        viewModel.error.map { $0.localizedDescription }.bind(to: errorLbl.rx.text).disposed(by: disposeBag)
        viewModel.artistsList.map { $0.count > 0 }.bind(to: errorLbl.rx.isHidden).disposed(by: disposeBag)
    }

    /// show list of songs for spacific arist
    /// - Parameter element: list of songs for the artist
//    private func showSongsList(element: [SongEntity]) {
//        let songsView = SongsViewController()
//        let songsViewModel = SongsListViewModel(songs: element)
//        songsView.viewModel = songsViewModel
////        navigationController?.pushViewController(songsView, animated: true)
//    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension AlbumsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.width
        let cellWidth = (width - 30) / 3 // compute your cell width
        return CGSize(width: cellWidth, height: cellWidth / 0.6)
    }
}
