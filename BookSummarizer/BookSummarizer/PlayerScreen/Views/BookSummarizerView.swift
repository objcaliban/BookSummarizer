//
//  BookSummarizerView.swift
//  BookSummarizer
//
//  Created by Yefremova on 01.08.2024.
//

import SwiftUI
import ComposableArchitecture

struct BookSummarizerView: View {
    let store: StoreOf<BookSummarizer>
    
    var body: some View {
        KeyPointsPlayerView(store: store)
    }
}

#Preview {
    BookSummarizerView(
        store: Store(initialState: BookSummarizer.State()) {
            BookSummarizer()
        }
    )
}