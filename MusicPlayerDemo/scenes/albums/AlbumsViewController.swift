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
    private let hPadding = CGFloat(4)
    @IBOutlet private var errorLbl: UILabel!
    private let disposeBag = DisposeBag()
    var viewModel: AlbumsViewModel!
    override func viewDidLoad() {
        super.viewDidLoad()
        albumsCollectionView.register(UINib(nibName: cellId, bundle: .none), forCellWithReuseIdentifier: cellId)
        bindToViewModel()
        viewModel.loadData(showLoader: true)
        addSearchToNavigationBar()
    }
    
    private lazy var results: ArtistsViewController = {
        ArtistCoordinator(self.navigationController).getArtistView()
    }()
    private func showAlbumsFor(artist:Artist){
        AlbumsCoordinator(self.navigationController).start(completion: nil, for: artist)
    }
    private func addSearchToNavigationBar() {
        let searchController = UISearchController(searchResultsController: results)
        results.didSelectArtist.bind(onNext: showAlbumsFor(artist:)).disposed(by: disposeBag)
        searchController.searchResultsUpdater = results
        searchController.searchBar.isTranslucent = false
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search for artist"
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
    
    private var cellId: String {
        return String(describing: AlbumCollectionCell.self)
    }
    
    private func bindToViewModel() {
        viewModel.showProgress
            .asDriver(onErrorJustReturn: false)
            .drive(onNext: showLoading(show:)).disposed(by: disposeBag)
        
        viewModel.albums
            .bind(to: albumsCollectionView.rx.items(cellIdentifier: cellId, cellType: AlbumCollectionCell.self)) { index, model, cell in
                cell.setData(model)
        }.disposed(by: disposeBag)
        
        albumsCollectionView.rx.setDelegate(self).disposed(by: disposeBag)
        albumsCollectionView.rx.modelSelected(Album.self).bind(onNext: viewModel.showSongsList(album:)).disposed(by: disposeBag)
        
        viewModel.error.map { $0.localizedDescription }.bind(to: errorLbl.rx.text).disposed(by: disposeBag)
        viewModel.albums.map { $0.count > 0 }.bind(to: errorLbl.rx.isHidden).disposed(by: disposeBag)
        
        
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension AlbumsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.width
        let cellWidth = width / 3
        return CGSize(width: cellWidth - hPadding, height: cellWidth / 0.8)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return hPadding
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
