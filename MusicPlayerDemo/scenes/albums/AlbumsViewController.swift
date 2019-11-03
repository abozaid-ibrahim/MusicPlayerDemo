//
//  ArtistsViewController.swift
//  MusicPlayerDemo
//
//  Created by abuzeid on 10/12/19.
//  Copyright © 2019 abuzeid. All rights reserved.
//

import RxSwift
import UIKit

final class AlbumsViewController: UIViewController, Loadable {
    @IBOutlet private var albumsCollectionView: UICollectionView!
    @IBOutlet private var errorLbl: UILabel!

    private let collectionCellsPadding = CGFloat(4)
    private let disposeBag = DisposeBag()
    var viewModel: AlbumsViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        albumsCollectionView.register(UINib(nibName: cellId, bundle: .none), forCellWithReuseIdentifier: cellId)
        bindToViewModel()
        addSearchToNavigationBar()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.loadData(showLoader: true)
    }

    private lazy var results: ArtistsViewController = {
        let artistsController = ArtistsViewController()
        artistsController.title = "Artists"
        artistsController.viewModel = ArtistsListViewModel()
        return artistsController
    }()
}

// MARK: AlbumsViewController (Private)

private extension AlbumsViewController {
    func showAlbumsFor(artist: Artist) {
        viewModel.showAlbums(of: artist)
    }

    func addSearchToNavigationBar() {
        let searchController = UISearchController(searchResultsController: results)
        (results.didSelectArtist.bind(onNext: showAlbumsFor(artist:))).disposed(by: disposeBag)
        searchController.searchResultsUpdater = results
        searchController.searchBar.isTranslucent = false
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search for artist"
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }

    var cellId: String {
        return String(describing: AlbumCollectionCell.self)
    }

    func bindToViewModel() {
        viewModel.showProgress
            .asDriver(onErrorJustReturn: false)
            .drive(onNext: showLoading(show:)).disposed(by: disposeBag)
        // set collectionview
        viewModel.albums
            .bind(to: albumsCollectionView.rx.items(cellIdentifier: cellId, cellType: AlbumCollectionCell.self)) { _, model, cell in
                cell.setData(model)
            }.disposed(by: disposeBag)

        albumsCollectionView.rx.setDelegate(self).disposed(by: disposeBag)
        albumsCollectionView.rx.modelSelected(Album.self).bind(onNext: viewModel.showSongsList(album:)).disposed(by: disposeBag)

        // handle error
        Observable.merge([viewModel.error.map { $0.localizedDescription },
                          viewModel.albums.map { $0.count > 0 ? "" : "You don't have any offline music" }])
            .bind(to: errorLbl.rx.text).disposed(by: disposeBag)
        viewModel.albums.map { $0.count > 0 }.bind(to: errorLbl.rx.isHidden).disposed(by: disposeBag)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension AlbumsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout _: UICollectionViewLayout, sizeForItemAt _: IndexPath) -> CGSize {
        let width = collectionView.bounds.width
        let cellWidth = (width / 3) - collectionCellsPadding
        return CGSize(width: cellWidth , height: cellWidth / 0.8)
    }

    func collectionView(_: UICollectionView, layout _: UICollectionViewLayout, minimumInteritemSpacingForSectionAt _: Int) -> CGFloat {
        return collectionCellsPadding
    }

    func collectionView(_: UICollectionView, layout _: UICollectionViewLayout, minimumLineSpacingForSectionAt _: Int) -> CGFloat {
        return collectionCellsPadding
    }
}
