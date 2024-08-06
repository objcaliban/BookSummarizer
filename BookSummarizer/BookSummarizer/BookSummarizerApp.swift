//
//  BookSummarizerApp.swift
//  BookSummarizer
//
//  Created by Yefremova on 01.08.2024.
//

import SwiftUI
import ComposableArchitecture

@main
struct BookSummarizerApp: App {
    static let store = Store(initialState: BookSummarizer.State()) {
        BookSummarizer()
    }
    
    var body: some Scene {
        WindowGroup {
            BookSummarizerView(
                store: BookSummarizerApp.store
            )
        }
    }
}
