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

final class MiniPlayerTests: QuickSpec {
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
                        .to(equal([Recorded.next(0, .sleep),Recorded.next(0, AudioPlayer.State.playing(item: MocksRepo.songs.first!))]))
                }
                it("play music in spacific index") {
                    player.state.bind(to: stateObserver).disposed(by: disposeBag)
                    schedular.start()
                    player.playAudio(form: MocksRepo.songs,startFrom: 2)
                    expect(stateObserver.events)
                        .to(equal([Recorded.next(0, .sleep),Recorded.next(0, AudioPlayer.State.playing(item: MocksRepo.songs[2]))]))
                    
                }
                
            
                
            }
        }
    }
}

struct MocksRepo{
    static let songs = [SongEntity.init(id: "11", userId: "11", user: nil, streamUrl: "http:ww"),
                        SongEntity.init(id: "12", userId: "11", user: nil, streamUrl: "http:ww"),
                        SongEntity.init(id: "13", userId: "11", user: nil, streamUrl: "http:ww"),
                        SongEntity.init(id: "14", userId: "11", user: nil, streamUrl: nil),
                        SongEntity.init(id: "15", userId: "11", user: nil, streamUrl: "http:ww")
    ]
}
