//
//  MusicPlayerDemoTests.swift
//  MusicPlayerDemoTests
//
//  Created by abuzeid on 10/12/19.
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

class MiniPlayerTests: QuickSpec {
    override func spec() {
        describe("Music Player") {
            context("Connection is stable and user have song to play") {
                var player: AudioPlayer!
                var schedular: TestScheduler!
                var songsObserver: TestableObserver<[SongEntity]>!
                var songsViewModel: SongsViewModel!
                var disposeBag = DisposeBag()
                beforeEach {
                    player = AudioPlayer()
                    schedular = TestScheduler(initialClock: 0)
                    songsObserver = schedular.createObserver([SongEntity].self)
                    songsViewModel = SongsListViewModel(songs: MocksRepo.songs)
                    disposeBag = DisposeBag()
                }
                it("send play command to music player") {
                    let musicObserver = schedular.createObserver([SongEntity].self)
                    schedular.start()
                    AudioPlayer.shared.playAudio(form: MocksRepo.songs)
////                    expect(AudioPlayer.shared.state).to(equal( [
//                        Recorded.next(0, AudioPlayer.State.playing(item: musicObserver.first!)),
//                    ]))
                }
                it("play music in spacific index") {
//                    let music = schedular.createObserver([SongEntity].self)
//                    player.playAudio(form: music.tol)
//                    schedular.start()
//                    expect(player.state).to(equal([
//                        Recorded.next(0, AudioPlayer.State.playing(item: music.first!)),
//                    ]))
                }
                
                context("Music player has no connection") {
                    it("it emits an error for the user") {
//                        let text = schedular.createObserver(String.self)
//                        
//                        songsViewModel.chooses.asObservable().subscribe(text).disposed(by: disposeBag)
//                        schedular.start()
//                        songsViewModel.combineSelection(with: ("Arnage", "Arnage"))
//                        expect(text.events).to(equal([
//                            Recorded.next(0, "Model: \(manufacturer.1)\n\("Arnage"): \("Arnage")"),
//                        ]))
                    }
                }
                
            }
        }
    }
}

struct MocksRepo{
    static let songs = [SongEntity.init(id: "11", userId: "11", user: nil, streamUrl: "http:ww"),
                        SongEntity.init(id: "12", userId: "11", user: nil, streamUrl: "http:ww"),
                        SongEntity.init(id: "13", userId: "11", user: nil, streamUrl: "http:ww")]
}
