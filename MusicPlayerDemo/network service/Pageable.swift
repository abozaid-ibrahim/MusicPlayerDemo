//
//  Pageable.swift
//  MusicPlayerDemo
//
//  Created by abuzeid on 10/12/19.
//  Copyright © 2019 abuzeid. All rights reserved.
//

import Foundation
import Foundation

final class Page {
    var currentPage: Int = 0
    var maxPages: Int = 1
    var countPerPage: Int = 15
    var isFetchingData = false
    var fetchedItemsCount = 0
    var shouldLoadMore: Bool {
        (currentPage < maxPages) && (!isFetchingData)
    }
}

protocol Pageable {
    func loadCells(for indexPaths: [IndexPath])
}
