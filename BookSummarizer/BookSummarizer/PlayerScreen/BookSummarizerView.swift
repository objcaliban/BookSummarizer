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
            AsyncImage(url: store.coverURL /*"https://m.media-amazon.com/images/I/713AIrfxlqL._AC_UF1000,1000_QL80_.jpg"*/) { phase in
                if let image = phase.image {
                    image
                        .resizable()
                        .scaledToFit()
                } else if phase.error != nil {
                    Text("There was an error loading the image.")
                } else {
                    ProgressView()
                }
            }
            .frame(width: 200, height: 200)
            
            Spacer().frame(height: 50)
            HStack {
                Image(systemName: "backward.end.fill")
                    .onTapGesture {
                        store.send(.view(.backwardTapped))
                    }
                Image(systemName: store.isAudioPlaying ? "play.fill" : "pause.fill")
                    .onTapGesture {
                        store.send(.view(store.isAudioPlaying ? .stopTapped : .startTapped))
                    }
                Image(systemName: "forward.end.fill")
                    .onTapGesture {
                        store.send(.view(.forwardTapped))
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
