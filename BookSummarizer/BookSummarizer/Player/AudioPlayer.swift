//
//  AudioPlayer.swift
//  BookSummarizer
//
//  Created by Yefremova on 01.08.2024.
//

import AVFoundation
import Combine

class AudioPlayer {
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
        /// added safe value access. it is necessary that there are no problems with the slider when the player is still loading meta data
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
        guard let url else { throw SummarizerError.invalidUrl }
        /// in a real project, I would add a more extensive error handle, for which it takes more time
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
