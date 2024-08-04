//
//  Player.swift
//  BookSummarizer
//
//  Created by Yefremova on 01.08.2024.
//

import Foundation

protocol Player {
    var isPlaying: Bool { get }
    var currentTime: Double { get set }
    var duration: Double { get }
    var playRate: Float { get set }
    
    func setup(with url: URL?) throws
    func play()
    func pause()
}
