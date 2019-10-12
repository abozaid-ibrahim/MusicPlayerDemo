//
//  FeedViewController.swift
//  MusicPlayerDemo
//
//  Created by abuzeid on 10/12/19.
//  Copyright © 2019 abuzeid. All rights reserved.
//

import UIKit
import RxSwift
final class FeedViewController: UIViewController {
  
    @IBOutlet private weak var tableView: UITableView!
    private let disposeBag = DisposeBag()
    private var viewModel = FeedListViewModel()
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.registerNib(String(describing: FeedTableCell.self))
        viewModel.feedsList
            .bind(to: tableView.rx.items(cellIdentifier: String(describing: FeedTableCell.self),
                                         cellType:  FeedTableCell.self)){ row, model, cell  in

                cell.setData(with: model)
        }.disposed(by: disposeBag)
        
//        tableView.rx.modelSelected(User.self)
        
    }
}


