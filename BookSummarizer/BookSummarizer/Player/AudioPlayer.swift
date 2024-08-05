//
//  AudioPlayer.swift
//  BookSummarizer
//
//  Created by Yefremova on 01.08.2024.
//

import AVFoundation

class AudioPlayer: Player {
    
    var isPlaying: Bool {
        return player?.timeControlStatus == .playing
    }
    
    var currentTime: Double {
        get {
            return player?.currentTime().seconds ?? 0.0
        }
        set {
            let newTime = CMTime(seconds: newValue, preferredTimescale: 600)
            player?.seek(to: newTime)
        }
    }
    
    var duration: Double {
        return player?.currentItem?.duration.seconds ?? 0.0
    }
    
    var playRate: Float = 1.0 {
        didSet {
            if isPlaying {
                player?.rate = playRate
            }
        }
    }
    
    private var player: AVPlayer?
    
    func setup(with url: URL?) throws {
        guard let url else { throw NSError() } // TODO: add specific error
        player = AVPlayer(url: url)
    }
    
    func play() {
        player?.rate = playRate
    }
    
    func pause() {
        player?.pause()
    }
}
