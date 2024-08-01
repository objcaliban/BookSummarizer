//
//  Book.swift
//  BookSummarizer
//
//  Created by Yefremova on 01.08.2024.
//

import SwiftUI

// TODO: consider removing useless(?) interface
protocol PlayItem {
    var name: String { get }
    var cover: Image { get }
    var chapters: [Chapter] { get }
}

struct Book: PlayItem {
    var name: String
    var cover: Image
    var chapters: [Chapter]
}
