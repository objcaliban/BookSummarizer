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
            cover
                .padding(.bottom, Const.Cover.bottomPadding)
            keyPointNumber
                .padding(.bottom, Const.KeyPointNumber.bottomPadding)
            chapterTitle
            slider
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
    
    var cover: some View {
        AsyncImage(url: store.coverURL) { phase in
            if let image = phase.image {
                image
                    .resizable()
                    .scaledToFit()
            } else if phase.error != nil {
                // TODO: add skeleton
                Text("There was an error loading the image.")
            } else {
                // TODO: add skeleton
                ProgressView()
            }
        }
        .containerRelativeFrame(.horizontal) { size, axis in
            size * Const.Cover.horizontalPartOfScreen
        }
        .aspectRatio(Const.Cover.sizeProporion, contentMode: .fill)
    }
    
    var keyPointNumber: some View {
        // TODO: replace mock
        Text("Key point 0 of 7")
            .textCase(.uppercase)
            .foregroundColor(.gray) // TODO: maybe use same colors from design
            .font(.footnote)
            .fontWeight(.bold)
    }
    
    var chapterTitle: some View {
        Text("yfyhdevc uefveufrvcu ufrveouv vtrggertvf trvvtvbgrtrtef tfrgbvgrtfbeerwb gfbrgfbvrfgt gtfrbbtr brt tbrbtrterw tbfve4wetrbv ")
            .font(.subheadline)
            .foregroundColor(.black)
            .multilineTextAlignment(.center)
            .frame(height: 40)
            .padding(.horizontal, 40)
    }
    
    var slider: some View {
        HStack(spacing: 0) {
            Text("00:00")
                .frame(width: 60)
            Slider(
                value: Binding(
                    get: { store.currentTime },
                    set: { value in }
                ),
                in: 0...store.duration
            )
            Text("00:00")
                .frame(width: 60)
        }
        .font(.footnote)
        .foregroundColor(.gray)
    }
}

extension BookSummarizerView {
    enum Const {
        enum Cover {
            /// to match the design (real app), the proportion of the picture (height/width) was calculated
            static let sizeProporion = 1.5
            /// according to designs (real app), the picture should occupy half of the screen horizontally
            static let horizontalPartOfScreen = 0.5
            static let bottomPadding: CGFloat = 40
        }
        
        enum KeyPointNumber {
            static let bottomPadding: CGFloat = 30
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
