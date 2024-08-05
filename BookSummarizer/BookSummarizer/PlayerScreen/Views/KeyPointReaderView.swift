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
            title
                .padding(Const.titlePadding)
            text
                .padding(.horizontal, Const.textPadding)
            bottomControls
                .padding(.top, Const.Controls.topPadding)
                .padding(.bottom, Const.Controls.bottomPadding)
            
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
        HStack(spacing: Const.Controls.internalSpacing) {
            DirectionButton(direction: .backward, height: Const.Controls.height) {
                store.send(.view(.backwardTapped))
            }.opacity(store.keyPoints.isFirstKeyPoint ? 0 : 1)
            
            Text(String(format: Const.Controls.titleMask,
                        store.keyPoints.currentNumber, store.keyPoints.count))
                .font(.callout)
                .foregroundColor(.black)
            
            DirectionButton(direction: .forward, height: Const.Controls.height) {
                store.send(.view(.forwardTapped))
            }.opacity(store.keyPoints.isLastKeyPoint ? Const.Controls.hidden : Const.Controls.visible)
        }
    }
}

extension KeyPointReaderView {
    enum Const {
        static let titlePadding: CGFloat = 15
        static let textPadding: CGFloat = 15
        
        enum Controls {
            static let internalSpacing: CGFloat = 35
            static let topPadding: CGFloat = 40
            static let bottomPadding: CGFloat = 80
            static let height: CGFloat = 15
            
            static let hidden: CGFloat = 0
            static let visible: CGFloat = 1
            
            static let titleMask = "%d of %d"
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
