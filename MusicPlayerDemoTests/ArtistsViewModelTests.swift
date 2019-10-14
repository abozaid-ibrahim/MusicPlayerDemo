//
//  FeedViewModelTests.swift
//  MusicPlayerDemoTests
//
//  Created by abuzeid on 10/13/19.
//  Copyright © 2019 abuzeid. All rights reserved.
//

@testable import MusicPlayerDemo
import RxSwift
import XCTest
class FeedViewModelTests: XCTestCase {
    var viewModel: ArtistsViewModel!
    override func setUp() {
        viewModel = ArtistsListViewModel()
    }

    override func tearDown() {
        viewModel = .none
    }

    func testFilterAtistsFromAllMusic() {
        let data = [SongEntity(id: "0", userId: "100", user: .none, streamUrl: ""),
                    SongEntity(id: "2", userId: "101", user: .none, streamUrl: ""),
                    SongEntity(id: "4", userId: "102", user: .none, streamUrl: ""),
                    SongEntity(id: "22", userId: "101", user: .none, streamUrl: ""),
                    SongEntity(id: "3", userId: "100", user: .none, streamUrl: ""),
                    SongEntity(id: "1", userId: "100", user: .none, streamUrl: "")]
        let users = viewModel.sortMusicByArtist(data)
        XCTAssertEqual(users.count, 3)
//        XCTAssertEqual(users.first!.id!, "100")
//        XCTAssertEqual(users.last!.id!, "102")
    }

    func testSongsOfSingleArtist() {
        let data = [SongEntity(id: "0", userId: "100", user: .none, streamUrl: ""),
                    SongEntity(id: "2", userId: "101", user: .none, streamUrl: ""),
                    SongEntity(id: "4", userId: "102", user: .none, streamUrl: ""),
                    SongEntity(id: "22", userId: "101", user: .none, streamUrl: ""),
                    SongEntity(id: "3", userId: "100", user: .none, streamUrl: ""),
                    SongEntity(id: "1", userId: "100", user: .none, streamUrl: "")]
        let user = Artist(id: "101", permalink: .none, username: .none, uri: .none, permalinkUrl: .none, avatarUrl: .none)
//        viewModel.artist.asObservable().toArray().
        viewModel.songsOf(user: user)
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        measure {
            // Put the code you want to measure the time of here.
        }
    }
}
