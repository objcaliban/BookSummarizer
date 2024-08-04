//
//  SummarizerDataSourse.swift
//  BookSummarizer
//
//  Created by Yefremova on 01.08.2024.
//

import ComposableArchitecture
import Foundation

// TODO: maybe rename :)
protocol SummarizerDataSourceInterface {
    var currentPlayItem: PlayItem? { get }
    var currentKeyPoint: KeyPoint? { get }
    
    func setupDataSource() async
    func moveToNextChapter()
    func moveToPreviousChapter()
}

class SummarizerDataSource: SummarizerDataSourceInterface {
    @Dependency(\.playItemFetcher) var playItemFetcher
    
    var currentPlayItem: PlayItem?
    var currentKeyPoint: KeyPoint?
    var isErrorAccured: Bool = false
    
    func setupDataSource() async {
        do {
            /// if this were a real application, here I would be able to make a request to receive the book
            /// for example, I made a request and received a book
            let playItem = try await self.playItemFetcher.fetchPlayItem()
            print("✅", playItem)
            self.currentPlayItem = playItem
            // TODO: handle current key point
            self.currentKeyPoint = playItem.keyPoints.first
        } catch {
            self.isErrorAccured = true
        }
    }
    
    func moveToNextChapter() {
        
    }
    
    func moveToPreviousChapter() {
        
    }
}
