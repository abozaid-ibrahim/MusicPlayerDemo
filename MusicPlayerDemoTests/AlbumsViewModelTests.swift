//
//  AlbumsViewModelTests.swift
//  MusicPlayerDemoTests
//
//  Created by abuzeid on 11/2/19.
//  Copyright © 2019 abuzeid. All rights reserved.
//

@testable import MusicPlayerDemo
import XCTest
import Nimble
import Quick
import RxNimble
import RxOptional
import RxSwift
import RxSwiftExt
import RxTest

final class AlbumsViewModelTests: QuickSpec {
    override func spec() {
        describe("Albums ViewModel") {
            context("show list of albums from online api") {
                var schedular: TestScheduler!
                var viewModel: AlbumsListViewModel!
                var albumsObserver: TestableObserver<[Album]>!
                var disposeBag = DisposeBag()
                beforeEach {
                    schedular = TestScheduler(initialClock: 0)
                     viewModel =  AlbumsListViewModel(apiClient: SuccessMockedApi(), artist: nil)
                    albumsObserver = schedular.createObserver([Album].self)
                    disposeBag = DisposeBag()
                }
                it("update ui with list of artists") {
                    //artist == nil datasoruce is offline
                    viewModel =  AlbumsListViewModel(apiClient: SuccessMockedApi(), artist: nil,db: MockedDB() )
                    viewModel.albums.bind(to: albumsObserver).disposed(by: disposeBag)
                    schedular.start()
                    expect(albumsObserver.events)
                        .to(equal([Recorded.next(0, Album()),
                                   Recorded.next(0, Album())]))
                }
                it("show error if we have") {
//                    player.state.bind(to: stateObserver).disposed(by: disposeBag)
//                    schedular.start()
//                    player.playAudio(form: MocksRepo.songs,startFrom: 2)
//                    expect(stateObserver.events)
//                        .to(equal([Recorded.next(0, .sleep),
//                                   Recorded.next(0, AudioPlayer.State.playing(item: MocksRepo.songs[2]))]))
                    
                }
                
                it("show hint to user to add offline albums") {
//                    player.state.bind(to: stateObserver).disposed(by: disposeBag)
//                    let action = schedular.createColdObservable([Recorded.next(4, UITapGestureRecognizer())])
//                    player.playAudio(form: MocksRepo.songs,startFrom: 2)
//                    player.playPause(action.asObservable())
//                    schedular.start()
//                    expect(stateObserver.events)
//                        .to(equal([Recorded.next(0, .sleep),
//                                   Recorded.next(0, AudioPlayer.State.playing(item: MocksRepo.songs[2])),
//                                   Recorded.next(4, AudioPlayer.State.paused(item: MocksRepo.songs[2]))]))
                    
                }
                it("show list of songs of album") {
                    
                }
                
            }
        }
    }
}
class SuccessMockedApi:ApiClient{
    func getData<T>(of request: RequestBuilder) -> Observable<T?> where T : Decodable {

            return Observable.create { observer in
                let x = AlbumsResponse.init(topalbums: nil)
                observer.onNext(x)
                return Disposables.create()
            }
        }
}
class MockedDB :DataBaseOperations{
    func getAll(of obj: MockedDB.Cachable.Type) -> [MockedDB.Cachable] {
        return [Album(),Album()]
    }
    
}
