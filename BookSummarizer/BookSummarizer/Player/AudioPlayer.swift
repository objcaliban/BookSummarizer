//
//  AudioPlayer.swift
//  BookSummarizer
//
//  Created by Yefremova on 01.08.2024.
//

import AVFoundation
import Combine

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
        if let seconds = player?.currentItem?.duration.seconds,
           seconds >= 0 {
            return seconds
        }
        return 0.0
    }
    
    var playRate: Float = 1.0 {
        didSet {
            if isPlaying {
                player?.rate = playRate
            }
        }
    }
    
    private var player: AVPlayer?
    private var cancellables = Set<AnyCancellable>()
    
    func setup(with url: URL?) throws {
        guard let url else { throw NSError() } // TODO: add specific error
        player = AVPlayer(url: url)
        setupObservers()
    }
    
    func play() {
        player?.rate = playRate
    }
    
    func pause() {
        player?.pause()
    }
    
    private func setupObservers() {
        NotificationCenter.default.publisher(for: .AVPlayerItemDidPlayToEndTime, object: player?.currentItem)
            .sink { _ in
                BookSummarizerApp.store.send(.player(.handlePlayingFinish))
            }
            .store(in: &cancellables)
        
        player?.currentItem?.publisher(for: \.duration)
            .compactMap { $0.seconds.isFinite ? $0.seconds : nil }
            .sink { duration in
                BookSummarizerApp.store.send(.player(.updateDuration))
            }
            .store(in: &cancellables)
    }
}
