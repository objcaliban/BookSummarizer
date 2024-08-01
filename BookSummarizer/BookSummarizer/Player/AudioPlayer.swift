//
//  AudioPlayer.swift
//  BookSummarizer
//
//  Created by Yefremova on 01.08.2024.
//

import AVKit

class AudioPlayer: Player {
    var isPlaying: Bool {
        player?.isPlaying ?? false
    }
    
    var currentTime: TimeInterval {
        get { player?.currentTime ?? 0 }
        set { player?.currentTime = newValue }
    }
    
    var duration: TimeInterval {
        player?.duration ?? 0
    }
    
    var playSpeed: Float {
        get { player?.rate ?? 0 }
        set { player?.rate = newValue }
    }
    
    private var player: AVAudioPlayer?
    
    func play() {
        player?.play()
    }
    
    func pause() {
        player?.pause()
    }
    
    func stop() {
        player?.stop()
    }
}

