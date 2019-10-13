//
//  ActivityIndicator.swift
//  MusicPlayerDemo
//
//  Created by abuzeid on 10/13/19.
//  Copyright © 2019 abuzeid. All rights reserved.
//

import Foundation
import UIKit

protocol Loadable {
    func showLoading(show: Bool)
}

extension Loadable where Self: UIViewController {
    func showLoading(show: Bool) {
        if show {
            self.showLoading()
        } else {
            self.hideLoading()
        }
    }

    private func showLoading() {
        let activityView = UIActivityIndicatorView(style: .gray)
        activityView.center = self.view.center
        self.view.addSubview(activityView)
        activityView.startAnimating()
    }

    private func hideLoading() {
        guard let firstView = self.view.subviews.filter({ type(of: $0) == UIActivityIndicatorView.self }).first,
            let progress = firstView as? UIActivityIndicatorView else { return }

        progress.stopAnimating()
        progress.removeFromSuperview()
    }
}
