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

final class AudioPlayer: NSObject {
    private var audioPlayer: AVQueuePlayer?
    private var items: [AVPlayerItem] = []
    
    //    MARK: - Action Methods
    
    func playAudio(_ list: [URL]) {
        self.items.removeAll()
        self.items.append(contentsOf: list.map { AVPlayerItem(url: $0) })
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback)
            self.audioPlayer = AVQueuePlayer(items: self.items)
            self.audioPlayer?.play()
            
        } catch {
            print(error)
        }
    }
    
    func stopAudio() {
        self.audioPlayer?.pause()
    }
    
    func playNext() {
        self.audioPlayer?.advanceToNextItem()
    }
}
