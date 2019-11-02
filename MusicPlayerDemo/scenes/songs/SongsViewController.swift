//
//  SongsViewController.swift
//  MusicPlayerDemo
//
//  Created by abuzeid on 10/12/19.
//  Copyright © 2019 abuzeid. All rights reserved.
//

import RxCocoa
import RxOptional
import RxSwift
import UIKit

final class SongsViewController: UIViewController, Loadable {
    @IBOutlet private var tableView: UITableView!
    private let disposeBag = DisposeBag()
    var viewModel: SongsViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        bindToViewModel()
        addSaveBarButton()
        viewModel.loadData()
    }

    private func addSaveBarButton() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: #selector(onBarButtonClicked(s:)))
        viewModel.isCachedState
            .map { $0 ? "Delete" : "Save" }
        .debug()
            .bind(to: navigationItem.rightBarButtonItem!.rx.title)
            .disposed(by: disposeBag)
    }
    @objc private func onBarButtonClicked(s:Any){
        viewModel.changeOfflineMode()
    }
    private func configureTableView() {
        tableView.registerNib(SongTableCell.self)
        tableView.seperatorStyle()
    }

    private func bindToViewModel() {
        viewModel.showProgress
            .asDriver(onErrorJustReturn: false)
            .drive(onNext: showLoading(show:)).disposed(by: disposeBag)
        viewModel.tracksList
            .bind(to: tableView.rx.items(cellIdentifier:
                String(describing: SongTableCell.self), cellType: SongTableCell.self)) { _, model, cell in
                cell.setData(model)
            }.disposed(by: disposeBag)
        tableView.rx.modelSelected(Track.self).bind(onNext: viewModel.playSong(track:)).disposed(by: disposeBag)
    }
}
