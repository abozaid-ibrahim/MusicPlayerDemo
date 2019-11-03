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
import RxSwift
import RxTest

 class MiniPlayerTests: QuickSpec {
    override func spec() {
        describe("Music Player") {
            context("Connection is stable and user have song to play") {
                var player: AudioPlayer!
                var schedular: TestScheduler!
                var stateObserver: TestableObserver<AudioPlayer.State>!
                var disposeBag = DisposeBag()
                beforeEach {
                    player = AudioPlayer()
                    schedular = TestScheduler(initialClock: 0)
                    stateObserver = schedular.createObserver(AudioPlayer.State.self)
                    disposeBag = DisposeBag()
                }
                it("send play command to music player and reiceve playing statae") {
                    
                    player.state.bind(to: stateObserver).disposed(by: disposeBag)
                    player.playAudio(form: MocksRepo.songs)
                    schedular.start()
                    expect(stateObserver.events)
                        .to(equal([Recorded.next(0, .sleep),
                                   Recorded.next(0, AudioPlayer.State.playing(item: MocksRepo.songs.first!))]))
                }
                it("play music in spacific index") {
                    player.state.bind(to: stateObserver).disposed(by: disposeBag)
                    schedular.start()
                    player.playAudio(form: MocksRepo.songs,startFrom: 2)
                    expect(stateObserver.events)
                        .to(equal([Recorded.next(0, .sleep),
                                   Recorded.next(0, AudioPlayer.State.playing(item: MocksRepo.songs[2]))]))
                    
                }
                
                it("pause item when it recieve pause action") {
                    player.state.bind(to: stateObserver).disposed(by: disposeBag)
                    let action = schedular.createColdObservable([Recorded.next(4, UITapGestureRecognizer())])
                    player.playAudio(form: MocksRepo.songs,startFrom: 2)
                    player.playPause(action.asObservable())
                    schedular.start()
                    expect(stateObserver.events)
                        .to(equal([Recorded.next(0, .sleep),
                                   Recorded.next(0, AudioPlayer.State.playing(item: MocksRepo.songs[2])),
                                   Recorded.next(4, AudioPlayer.State.paused(item: MocksRepo.songs[2]))]))
                    
                }
                
            }
        }
    }
}

fileprivate struct MocksRepo{
    static let songs = [SongEntity(id: "11", title: "title", streamUrl: "http://hhh.com"),
                        SongEntity(id: "12", title: "title", streamUrl: "http://hhh.com"),
                        SongEntity(id: "13", title: "title", streamUrl: "http://hhh.com"),
                        SongEntity(id: "14", title: "title", streamUrl: "http://hhh.com"),
                        SongEntity(id: "15", title: "title", streamUrl: "http://hhh.com")
    ]
}
