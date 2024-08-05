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
    @State private var playerSelectorOffset: CGFloat = 0
    
    var body: some View {
        ZStack {
            background.ignoresSafeArea()
            if showPlayer {
                KeyPointsPlayerView(store: store)
            } else {
                KeyPointReaderView(store: store, toggleOffset: $playerSelectorOffset)
            }
            playerSelector
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
                .offset(y: playerSelectorOffset)
        }
        .onAppear {
            store.send(.view(.setupInitiated))
        }
    }
    
    private var background: some View {
        Color.playerBackground
    }
    
    var playerSelector: some View {
        RoundedRectangle(cornerRadius: Const.Selector.cornerRadius)
            .stroke(lineWidth: Const.Selector.stroke)
            .foregroundColor(.playerSelectorStroke)
            .overlay {
                GeometryReader { proxy in
                    let imageWidth = proxy.size.width * Const.Selector.imageProportion
                    ZStack(alignment: showPlayer ? .trailing : .leading) {
                        Color(.white)
                            .cornerRadius(Const.Selector.cornerRadius)
                        Circle()
                            .fill(.primaryBlue)
                            .padding(Const.Selector.selectedElementPadding)
                        HStack(spacing: 0) {
                            Image(systemName: "text.alignleft")
                                .resizable()
                                .scaledToFit()
                                .padding(Const.Selector.iconPadding)
                                .frame(width: imageWidth)
                                .foregroundColor(showPlayer ? .black : .white)
                            
                            Image(systemName: "headphones")
                                .resizable()
                                .scaledToFit()
                                .padding(Const.Selector.iconPadding)
                                .frame(width: imageWidth)
                                .foregroundColor(showPlayer ? .white : .black)
                        }
                        .fontWeight(.heavy)
                    }
                }
            }
            .frame(width: Const.Selector.width, height: Const.Selector.height)
            .onTapGesture {
                withAnimation(.linear(duration: Const.Selector.animationDuration)) {
                    showPlayer.toggle()
                }
            }
    }
    
    enum Const {
        enum Selector {
            static let cornerRadius: CGFloat = 54
            static let stroke: CGFloat = 1
            static let selectedElementPadding: CGFloat = 4
            static let iconPadding: CGFloat = 18
            static let imageProportion: CGFloat = 0.5
            
            static let height: CGFloat = 54
            static let width: CGFloat = 106
            
            static let animationDuration: CGFloat = 0.2
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
