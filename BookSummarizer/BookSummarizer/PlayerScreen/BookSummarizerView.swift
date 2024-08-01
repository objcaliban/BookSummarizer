//
//  BookSummarizerView.swift
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
            Image("book-cover-mock")
                .resizable()
                .scaledToFit()
                .frame(width: 200)
            Spacer().frame(height: 50)
            HStack {
                Image(systemName: "backward.end.fill")
                    .onTapGesture {
                        store.send(.backwardTapped)
                    }
                Image(systemName: store.isAudioPlaying ? "play.fill" : "pause.fill")
                    .onTapGesture {
                        store.send(store.isAudioPlaying ? .stopTapped : .startTapped)
                    }
                Image(systemName: "forward.end.fill")
                    .onTapGesture {
                        store.send(.forwardTapped)
                    }
            }
            
            
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
