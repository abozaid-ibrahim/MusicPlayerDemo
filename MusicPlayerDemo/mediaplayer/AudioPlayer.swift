//
//  AudioPlayer.swift
//  MusicPlayerDemo
//
//  Created by abuzeid on 10/12/19.
//  Copyright © 2019 abuzeid. All rights reserved.
//

import AVFoundation
import Foundation
import MobileCoreServices
import RxSwift

final class AudioPlayer: NSObject {
    private let disposeBag = DisposeBag()
    static let shared = AudioPlayer()
    private var audioPlayer: AVPlayer?
    private var items: [AVPlayerItem] = []
    private var list: [SongEntity] = []
    
    private var currentSongIndex = 0
    var state = BehaviorSubject<State>(value: .sleep)
    
    //    MARK: - Action Methods
    
    func playAudio(_ list: [SongEntity], startFrom: Int = 0) {
        self.currentSongIndex = startFrom
        self.items.removeAll()
        let songs = list.map { URL(string: $0.streamUrl ?? "")! }
        self.list = list
        self.items.append(contentsOf: songs.map { AVPlayerItem(url: $0) })
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback)
            self.audioPlayer = AVPlayer(playerItem: self.items[startFrom])
            self.audioPlayer?.play()
            self.state.onNext(.playing(item: list[startFrom]))
            self.notifyUI()
        } catch {
            print(error)
        }
    }
    
    func stopAudio() {
        self.audioPlayer?.pause()
    }
    
    private func notifyUI() {
        self.state.onNext(.playing(item: self.list[currentSongIndex]))
    }
    
    func playNext() {
        guard (self.currentSongIndex + 1) < self.items.count else {
            return
        }
        self.currentSongIndex += 1
        self.audioPlayer?.replaceCurrentItem(with: self.items[currentSongIndex])
        self.audioPlayer?.play()
        self.notifyUI()
    }
    
    func playPrev() {
        guard (self.currentSongIndex - 1) >= 0 else {
            return
        }
        self.currentSongIndex -= 1
        self.audioPlayer?.replaceCurrentItem(with: self.items[currentSongIndex])
        self.audioPlayer?.play()
        self.notifyUI()
    }
    
    func playPause(_ action: Observable<UITapGestureRecognizer>) {
        Observable.combineLatest(self.state, action).subscribe(onNext: { [unowned self] state, _ in
            if case .playing = state {
                self.stopAudio()
            } else {
                self.playNext()
            }
            
        }).disposed(by: self.disposeBag)
    }
    
    enum State: Equatable {
        static func == (lhs: AudioPlayer.State, rhs: AudioPlayer.State) -> Bool {
            switch (lhs, rhs) {
                case let (.playing(a), .playing(item: b)),
                     let (.paused(a), .paused(b)):
                    return a.id == b.id
                case (.sleep, .sleep):
                    return true
                default:
                    return false
            }
        }
        
        case playing(item: SongEntity), paused(item: SongEntity), sleep
    }
}
