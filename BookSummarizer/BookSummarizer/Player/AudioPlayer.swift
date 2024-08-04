//
//  AudioPlayer.swift
//  BookSummarizer
//
//  Created by Yefremova on 01.08.2024.
//

import AVFoundation

class AudioPlayer: NSObject, Player {
    private var player: AVPlayer?
    
    func setup(with url: URL?) throws {
        guard let url else { throw NSError() } // TODO: add specific error
        player = AVPlayer(url: url)
    }
    
    func play() {
        player?.play()
    }
    
    func pause() {
        player?.pause()
    }
}
