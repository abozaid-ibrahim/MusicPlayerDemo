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
/// the audio player file that plays the songs
final class AudioPlayer: NSObject {
    private let disposeBag = DisposeBag()
    private var audioPlayer: AVPlayer?
    private var items: [AVPlayerItem?] = []
    private var list: [SongEntity] = []
    private var currentSongIndex = 0
    var state = BehaviorSubject<State>(value: .sleep)
    private var localState: State = .sleep
    static let shared = AudioPlayer()
    
    //    MARK: - Action Methods
    
    /// initialize the audio palyer and set default values of the player attributes
    /// - Parameter list: list of songs model
    /// - Parameter startFrom: the index that should start playing the song from
    func playAudio(form list: [SongEntity], startFrom: Int = 0) {
        currentSongIndex = startFrom
        items.removeAll()
        let songs = list.map { URL(string: $0.streamUrl ?? "") }
        self.list = list
        let corruptUrl = URL(string: "https://api-v2.hearthis.at/")!
        items.append(contentsOf: songs.map { AVPlayerItem(url: $0 ?? corruptUrl) })
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback)
            audioPlayer = AVPlayer(playerItem: items[startFrom])
            audioPlayer?.play()
            notifyUIWithPlayingState()
        } catch {
            state.onNext(.error(error.localizedDescription))
        }
    }
    
    /// stop playing the current song
    func stopAudio() {
        audioPlayer?.pause()
        state.onNext(.paused(item: list[currentSongIndex]))
    }
    
    /// update the ui with the new state of the app
    private func notifyUIWithPlayingState() {
        state.onNext(.playing(item: list[currentSongIndex]))
    }
    
    func resume() {
        guard items.count > 0 else {
            return
        }
        audioPlayer?.play()
        notifyUIWithPlayingState()
    }
    
    /// play the next song
    func playNext() {
        guard (currentSongIndex + 1) < items.count else {
            return
        }
        currentSongIndex += 1
        audioPlayer?.replaceCurrentItem(with: items[currentSongIndex])
        audioPlayer?.play()
        notifyUIWithPlayingState()
    }
    
    /// play backword song
    func playPrev() {
        guard (currentSongIndex - 1) >= 0 else {
            return
        }
        currentSongIndex -= 1
        audioPlayer?.replaceCurrentItem(with: items[currentSongIndex])
        audioPlayer?.play()
        notifyUIWithPlayingState()
    }
    
    /// play or pause according to the current player state
    /// - Parameter action: the tap gesture event from the ui
    func playPause(_ action: Observable<UITapGestureRecognizer>) {
        action.withLatestFrom(state).subscribe(onNext: { [unowned self] state in
            if case .playing = state {
                self.stopAudio()
            } else if case .paused = state {
                self.resume()
            } else {}
            
        }).disposed(by: disposeBag)
    }
    
    /// enum to define the current state of the player
    enum State: Equatable {
        case playing(item: SongEntity), paused(item: SongEntity), sleep, error(String)
        static func == (lhs: AudioPlayer.State, rhs: AudioPlayer.State) -> Bool {
            switch (lhs, rhs) {
            case let (.playing(a), .playing(item: b)),
                 let (.paused(a), .paused(b)):
                return a.title == b.title
            case (.sleep, .sleep):
                return true
            case let (.error(a), .error(item: b)):
                return a == b
            default:
                return false
            }
        }
    }
}

struct SongEntity {    
    let id:String
    let title: String
    var streamUrl: String?
    
}
