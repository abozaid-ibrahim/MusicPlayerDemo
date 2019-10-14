//
//  FeedViewModelTests.swift
//  MusicPlayerDemoTests
//
//  Created by abuzeid on 10/13/19.
//  Copyright © 2019 abuzeid. All rights reserved.
//

@testable import MusicPlayerDemo
import RxBlocking
import RxSwift
import XCTest

class FeedViewModelTests: XCTestCase {
    var viewModel: ArtistsViewModel!
    override func setUp() {
        viewModel = ArtistsListViewModel(apiClient: MockedApi())
    }

    override func tearDown() {
        viewModel = .none
    }

    func testFilterAtistsFromAllMusic() {
        viewModel.loadData(showLoader: false)
        let users = try! viewModel.artistsList.toBlocking(timeout: 1).first()!

        XCTAssertEqual(users.count, 3)
        XCTAssertEqual(users.first!.id!, "100")
        XCTAssertEqual(users.last!.id!, "102")
    }

    func testSongsOfSingleArtist() {
        viewModel.loadData(showLoader: false)
        let user0 = Artist(id: "100", permalink: .none, username: .none, uri: .none, permalinkUrl: .none, avatarUrl: .none)
        DispatchQueue.global().asyncAfter(deadline: .now() + 0.4) {
            self.viewModel.songsOf(user: user0)
            self.viewModel.artistSongsList.onCompleted()
        }
        let songs = try! viewModel.artistSongsList.toBlocking(timeout: 1).first()!
        viewModel.songsOf(user: user0)
        XCTAssertEqual(songs.count, 3)
    }
}

class MockedApi: ApiClient {
    func getData(of request: RequestBuilder) -> Observable<SongsList?> {
        return Observable.create { observer in
            let user0 = Artist(id: "100", permalink: .none, username: .none, uri: .none, permalinkUrl: .none, avatarUrl: .none)
            let user1 = Artist(id: "101", permalink: .none, username: .none, uri: .none, permalinkUrl: .none, avatarUrl: .none)
            let user2 = Artist(id: "102", permalink: .none, username: .none, uri: .none, permalinkUrl: .none, avatarUrl: .none)
            let data = [SongEntity(id: "0", userId: "100", user: user0, streamUrl: ""),
                        SongEntity(id: "2", userId: "101", user: user1, streamUrl: ""),
                        SongEntity(id: "4", userId: "102", user: user2, streamUrl: ""),
                        SongEntity(id: "22", userId: "101", user: user1, streamUrl: ""),
                        SongEntity(id: "3", userId: "100", user: user0, streamUrl: ""),
                        SongEntity(id: "1", userId: "100", user: user0, streamUrl: "")]
            observer.onNext(data)
            return Disposables.create()
        }
    }
}
