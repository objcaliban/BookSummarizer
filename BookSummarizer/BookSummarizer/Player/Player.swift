//
//  Player.swift
//  BookSummarizer
//
//  Created by Yefremova on 01.08.2024.
//

import Foundation

protocol Player {
    var isPlaying: Bool { get }
    
    var currentTime: TimeInterval { get set }
    var duration: TimeInterval { get }
    
    var playSpeed: Float { get set }
    
    func play()
    func pause()
}
