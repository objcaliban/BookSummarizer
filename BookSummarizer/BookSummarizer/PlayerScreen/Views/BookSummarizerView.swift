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
    @State private var showPlayer = true
    
    var body: some View {
        ZStack {
            background.ignoresSafeArea()
            if showPlayer {
                KeyPointsPlayerView(store: store)
            } else {
                KeyPointReaderView(store: store)
            }

                playerSelector
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
        }
        .onAppear {
            store.send(.view(.setupInitiated))
        }
    }
    
    private var background: some View {
        Color.playerBackground
    }
    
    var playerSelector: some View {
        RoundedRectangle(cornerRadius: 54)
            .stroke(lineWidth: 1)
            .foregroundColor(.gray)
            .overlay {
                GeometryReader { proxy in
                    let imageWidth = proxy.size.width / 2
                    ZStack(alignment: showPlayer ? .trailing : .leading) {
                        Color(.white)
                            .cornerRadius(54)
                        Circle()
                            .fill(.blue)
                            .padding(4)
                        HStack(spacing: 0) {
                            Image(systemName: "text.alignleft")
                                .resizable()
                                .scaledToFit()
                                .padding(19)
                                .frame(width: imageWidth)
                                .foregroundColor(showPlayer ? .black : .white)
                            
                            Image(systemName: "headphones")
                                .resizable()
                                .scaledToFit()
                                .padding(19)
                                .frame(width: imageWidth)
                                .foregroundColor(showPlayer ? .white : .black)
                        }
                        .fontWeight(.heavy)
                    }
                }
            }
            .frame(width: 106, height: 54)
            .onTapGesture {
                withAnimation(.linear(duration: 0.2)) {
                    showPlayer.toggle()
                }
            }
    }
}

#Preview {
    BookSummarizerView(
        store: Store(initialState: BookSummarizer.State()) {
            BookSummarizer()
        }
    )
}
