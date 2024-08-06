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
    @Binding var toggleOffset: CGFloat
    
    @State private var previousScrollOffset: CGFloat = 0
    @State private var contentHeight: CGFloat = 0
    @State private var screenHeight: CGFloat = 0
    
    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                title
                    .padding(Const.titlePadding)
                text
                    .padding(.horizontal, Const.textPadding)
                bottomControls
                    .padding(.top, Const.Controls.topPadding)
                    .padding(.bottom, Const.Controls.bottomPadding)
            }
            .background(
               internalContentReader
            )
            .onPreferenceChange(ScrollViewOffsetKey.self) { value in
                calculateTogleOffset(offset: value)
            }
            .onPreferenceChange(ScrollViewContentHeightKey.self) { value in
                contentHeight = value
            }
        }
        .background(
            scrollContentReader
        )
        .onPreferenceChange(ScreenHeightKey.self) { value in
            screenHeight = value
        }
        .coordinateSpace(name: Const.coordinateSpace)
        .onChange(of: contentHeight) {
            if contentHeight < screenHeight {
                toggleOffset = 0
            }
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
    
    private var internalContentReader: some View {
        GeometryReader { geometry in
            Color.clear
                .preference(key: ScrollViewContentHeightKey.self, value: geometry.size.height)
                .preference(key: ScrollViewOffsetKey.self,
                            value: geometry.frame(in: .named(Const.coordinateSpace)).minY)
        }
    }
    
    private var scrollContentReader: some View {
        GeometryReader { geometry in
            Color.clear
                .preference(key: ScreenHeightKey.self, value: geometry.size.height)
        }
    }
    
    private func calculateTogleOffset(offset: CGFloat) {
        let maxOffset = screenHeight - contentHeight
        let diff = offset - previousScrollOffset
        if offset < 0 && offset > maxOffset {
            if diff < 0 {
                toggleOffset = min(toggleOffset + abs(diff), 100)
            } else if diff > 0 {
                toggleOffset = max(toggleOffset - diff, 0)
            }
        }
        previousScrollOffset = offset
    }
}

extension KeyPointReaderView {
    enum Const {
        static let coordinateSpace = "scrollView"
        
        static let titlePadding: CGFloat = 15
        static let textPadding: CGFloat = 15
        
        enum Controls {
            static let internalSpacing: CGFloat = 35
            static let topPadding: CGFloat = 40
            static let bottomPadding: CGFloat = 80
            static let height: CGFloat = 15
            
            static let hidden: CGFloat = 0
            static let visible: CGFloat = 1
            
            static let titleMask = String(localized: "CurrentKeyPointOfTotalShort")
        }
    }
}
