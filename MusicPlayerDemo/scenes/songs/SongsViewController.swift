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

final class SongsViewController: UIViewController,Loadable {
    @IBOutlet private var tableView: UITableView!
    private let disposeBag = DisposeBag()
    var viewModel: SongsListViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        binding()
        viewModel.loadData()
    }

    /// set table view style and reigster cells
    private func configureTableView() {
        tableView.registerNib(SongTableCell.self)
        tableView.seperatorStyle()
    }

    /// bind ui attributes to view model state variables for example, title, and datasource
    private func binding() {
        viewModel.showProgress
                  .asDriver(onErrorJustReturn: false)
                  .drive(onNext: showLoading(show:)).disposed(by: disposeBag)
        viewModel.tracksList
            .bind(to: tableView.rx.items(cellIdentifier:
                String(describing: SongTableCell.self), cellType: SongTableCell.self)) { _, model, cell in
                cell.setData(model)
            }.disposed(by: disposeBag)

    }
}
