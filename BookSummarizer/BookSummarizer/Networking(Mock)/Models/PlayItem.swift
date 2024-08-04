//
//  PlayItem.swift
//  BookSummarizer
//
//  Created by Yefremova on 03.08.2024.
//

import Foundation

struct PlayItem: Codable {
    var name: String
    var cover: String
    var keyPoints: [KeyPoint]
}
