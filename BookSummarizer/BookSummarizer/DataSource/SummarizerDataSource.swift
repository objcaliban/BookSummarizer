//
//  SummarizerDataSourse.swift
//  BookSummarizer
//
//  Created by Yefremova on 01.08.2024.
//

import ComposableArchitecture
import Foundation

protocol SummarizerDataSourceInterface {
    var currentPlayItem: PlayItem? { get }
    var currentKeyPoint: KeyPoint? { get }
    var isFirstKeyPoint: Bool { get }
    var isLastKeyPoint: Bool { get }
    var accuredError: Error? { get }
    
    func setupDataSource() async
    func moveToNextKeyPoint()
    func moveToPreviousKeyPoint()
}

class SummarizerDataSource: SummarizerDataSourceInterface {
    @Dependency(\.playItemFetcher) var playItemFetcher
    
    var currentPlayItem: PlayItem?
    var currentKeyPoint: KeyPoint? { currentPlayItem?.keyPoints[safe: currentKeyPointIdx] }
    var accuredError: Error?
    
    var isLastKeyPoint: Bool {
        guard let currentPlayItem,
              let currentKeyPoint,
              currentKeyPoint.number != currentPlayItem.keyPoints.count else { return true }
        return false
    }
    
    var isFirstKeyPoint: Bool {
        currentKeyPoint?.number == 1
    }
    
    private var currentKeyPointIdx = 0
    
    func setupDataSource() async {
        do {
            /// if this were a real application, here I would be able to make a request to receive the book
            /// for example, I made a request and received a book
            let playItem = try await self.playItemFetcher.fetchPlayItem()
            self.currentPlayItem = playItem
            /// Here I would add logic to remember last key point
            /// so user could start playing from last remembered key point
        } catch {
            accuredError = error
        }
    }
    
    func moveToNextKeyPoint() {
        if !isLastKeyPoint {
            currentKeyPointIdx += 1
        }
    }
    
    func moveToPreviousKeyPoint() {
        if !isFirstKeyPoint {
            currentKeyPointIdx -= 1
        }
    }
}
