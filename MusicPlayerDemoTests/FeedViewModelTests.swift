//
//  FeedViewModelTests.swift
//  MusicPlayerDemoTests
//
//  Created by abuzeid on 10/13/19.
//  Copyright © 2019 abuzeid. All rights reserved.
//

import XCTest
@testable import MusicPlayerDemo

class FeedViewModelTests: XCTestCase {

    var viewModel: FeedListViewModel!
    override func setUp() {
viewModel = FeedListViewModel()
    }

    override func tearDown() {
        viewModel = .none
        
    }

    func testFilterAtistsFromAllMusic() {
        let data = [SongEntity.init(id: "1", userId: "100", user: .none, streamUrl: ""),SongEntity.init(id: "2", userId: "101", user: .none, streamUrl: ""),
        SongEntity.init(id: "3", userId: "100", user: .none, streamUrl: ""),
        SongEntity.init(id: "4", userId: "102", user: .none, streamUrl: "")]
//        let expected = []
//        XCTAssertEqual(reuslt, expected.count)
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
