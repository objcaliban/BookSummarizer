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
    var body: some Scene {
        WindowGroup {
            BookSummarizerView(
                store: Store(initialState: BookSummarizer.State()) {
                    BookSummarizer()
                        ._printChanges()
                }
            )
        }
    }
}
