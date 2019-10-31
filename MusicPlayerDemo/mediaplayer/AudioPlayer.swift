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
    private var items: [AVPlayerItem] = []
    private var list: [SongEntity] = []
    private var currentSongIndex = 0
    var state = BehaviorSubject<State>(value: .sleep)
    static let shared = AudioPlayer()

    //    MARK: - Action Methods

    /// initialize the audio palyer and set default values of the player attributes
    /// - Parameter list: list of songs model
    /// - Parameter startFrom: the index that should start playing the song from
    func playAudio(_ list: [SongEntity], startFrom: Int = 0) {
        currentSongIndex = startFrom
        items.removeAll()
        let songs = list.map { URL(string: $0.streamUrl ?? "")! }
        self.list = list
        items.append(contentsOf: songs.map { AVPlayerItem(url: $0) })
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback)
            audioPlayer = AVPlayer(playerItem: items[startFrom])
            audioPlayer?.play()
            state.onNext(.playing(item: list[startFrom]))
            notifyUI()
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
    private func notifyUI() {
        state.onNext(.playing(item: list[currentSongIndex]))
    }

    /// play the next song
    func playNext() {
        guard (currentSongIndex + 1) < items.count else {
            return
        }
        currentSongIndex += 1
        audioPlayer?.replaceCurrentItem(with: items[currentSongIndex])
        audioPlayer?.play()
        notifyUI()
    }

    /// play backword song
    func playPrev() {
        guard (currentSongIndex - 1) >= 0 else {
            return
        }
        currentSongIndex -= 1
        audioPlayer?.replaceCurrentItem(with: items[currentSongIndex])
        audioPlayer?.play()
        notifyUI()
    }

    /// play or pause according to the current player state
    /// - Parameter action: the tap gesture event from the ui
    func playPause(_ action: Observable<UITapGestureRecognizer>) {
        Observable.combineLatest(state, action).subscribe(onNext: { [unowned self] state, _ in
            if case .playing = state {
                self.stopAudio()
            } else {
                self.playNext()
            }

        }).disposed(by: disposeBag)
    }

    /// enum to define the current state of the player
    enum State: Equatable {
        case playing(item: SongEntity), paused(item: SongEntity), sleep, error(String)
        static func == (lhs: AudioPlayer.State, rhs: AudioPlayer.State) -> Bool {
            switch (lhs, rhs) {
            case let (.playing(a), .playing(item: b)),
                 let (.paused(a), .paused(b)):
                return a.id == b.id
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
