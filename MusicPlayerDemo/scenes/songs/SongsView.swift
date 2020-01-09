//
//  SongsViewController.swift
//  MusicPlayerDemo
//
//  Created by abuzeid on 10/12/19.
//  Copyright © 2019 abuzeid. All rights reserved.
//

import UIKit
protocol SongsViewType: class, Loadable {
    func setActionTitle(with value: String)
    func set(error: Error)
    func reloadData()
}

final class SongsView: UIViewController {
    @IBOutlet private var tableView: UITableView!
    private var controller: SongsControllerType!

    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        addSaveBarButton()
        controller.loadData()
    }

    func set(controller: SongsControllerType) {
        self.controller = controller
    }
}

// MARK: SongsView Notifiers

extension SongsView: SongsViewType {
    func setActionTitle(with value: String) {
        navigationItem.rightBarButtonItem?.title = value
    }

    func set(error: Error) {
        log(.error, error)
    }

    func reloadData() {
        tableView.reloadData()
    }
}

// MARK: SongsView Setup (Private)

private extension SongsView {
    func addSaveBarButton() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: #selector(onBarButtonClicked(s:)))
    }

    @objc func onBarButtonClicked(s _: Any) {
        controller.changeOfflineMode()
    }

    func configureTableView() {
        tableView.dataSource = self
        tableView.registerNib(SongTableCell.self)
    }
}

// MARK: Tableview Datasource

extension SongsView: UITableViewDataSource {
    public func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return controller.tracksList.count
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: SongTableCell.self)) as! SongTableCell
        cell.setData(controller.tracksList[indexPath.row])
        return cell
    }
}
