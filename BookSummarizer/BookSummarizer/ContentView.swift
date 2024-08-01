//
//  ContentView.swift
//  BookSummarizer
//
//  Created by Yefremova on 01.08.2024.
//

import SwiftUI
import ComposableArchitecture

struct BookSummarizerView: View {
    let store: StoreOf<BookSummarizerFeature>
    
    var body: some View {
        VStack {
            Image(systemName: store.isAudioPlaying ? "play" : "pause")
                .onTapGesture {
                    store.isAudioPlaying ? store.send(.stopTapped) : store.send(.startTapped)
                }
            Image("book-cover-mock")
                .resizable()
                .scaledToFit()
        }
    }
}

#Preview {
    BookSummarizerView(
        store: Store(initialState: BookSummarizerFeature.State()) {
            BookSummarizerFeature()
        }
    )
}
