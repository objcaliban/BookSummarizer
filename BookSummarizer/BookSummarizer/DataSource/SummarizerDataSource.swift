//
//  SummarizerDataSourse.swift
//  BookSummarizer
//
//  Created by Yefremova on 01.08.2024.
//

import Foundation

// TODO: consider removing useless(?) interface
protocol SummarizerDataSource {
    var currentPlayItem: PlayItem { get }
    var currentChapter: Chapter { get }
    
    mutating func moveToNextChapter()
    mutating func moveToPreviousChapter()
}

struct BookDataSource: SummarizerDataSource {
    var currentPlayItem: any PlayItem

    var currentChapter: Chapter

    mutating func moveToNextChapter() {
        
    }

    mutating func moveToPreviousChapter() {
        
    }
}
