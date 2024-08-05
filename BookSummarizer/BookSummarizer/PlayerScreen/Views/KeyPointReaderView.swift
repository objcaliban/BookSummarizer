//
//  KeyPointReader.swift
//  BookSummarizer
//
//  Created by Yefremova on 05.08.2024.
//

import SwiftUI
import ComposableArchitecture

struct KeyPointReaderView: View {
    let store: StoreOf<BookSummarizer>
    
    init(store: StoreOf<BookSummarizer>) {
        self.store = store
    }
    
    var body: some View {
        ScrollView {
            title.padding(15)
            text.padding(.horizontal, 15)
            bottomControls.padding(.top, 40)
        }
    }
    
    private var title: some View {
        Text(store.keyPointReader.title)
            .frame(maxWidth: .infinity, alignment: .leading)
            .font(.title2)
            .fontDesign(.serif)
            .fontWeight(.bold)
            .foregroundColor(.black)
    }
    
    private var text: some View {
        Text(store.keyPointReader.text)
            .fontDesign(.serif)
            .multilineTextAlignment(.leading)
            .foregroundColor(.black)
    }
    
    private var bottomControls: some View {
        HStack(spacing: 35) {
            DirectionButton(direction: .backward, height: 15) {
                store.send(.view(.backwardTapped))
            }.opacity(store.keyPoints.isFirstKeyPoint ? 0 : 1)
            
            Text("\(store.keyPoints.currentNumber) of \(store.keyPoints.count)")
                .font(.callout)
                .foregroundColor(.black)
            
            DirectionButton(direction: .forward, height: 15) {
                store.send(.view(.forwardTapped))
            }.opacity(store.keyPoints.isLastKeyPoint ? 0 : 1)
        }
    }
}

#Preview {
    KeyPointReaderView(
        store: Store(initialState: BookSummarizer.State()) {
            BookSummarizer()
        }
    )
}

