//
//  KeyPointsPlayerView.swift
//  BookSummarizer
//
//  Created by Yefremova on 03.08.2024.
//

import SwiftUI
import ComposableArchitecture

struct KeyPointsPlayerView: View {
    let store: StoreOf<BookSummarizer>
    
    init(store: StoreOf<BookSummarizer>) {
        self.store = store
        let thumbImage = UIImage(systemName: "circle.fill")
        UISlider.appearance().tintColor = UIColor.primaryBlue
        UISlider.appearance().setThumbImage(thumbImage, for: .normal)
    }
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                cover
                    .frame(
                        width: geometry.size.width * Const.Cover.horizontalPartOfScreen,
                        height: (geometry.size.width * Const.Cover.horizontalPartOfScreen) * Const.Cover.sizeProporion
                    )
                    .cornerRadius(10)
                    .padding(.bottom, Const.Cover.bottomPadding)
                    .padding(.top, Const.Cover.topPadding)
                keyPointNumber
                    .padding(.bottom, Const.KeyPointNumber.bottomPadding)
                chapterTitle
                    .padding(.bottom, Const.ChapterTitle.bottomPadding)
                slider
                    .padding(.bottom, Const.Slider.bottomPadding)
                speedLabel
                    .padding(.bottom, Const.SpeedLabel.bottomPadding)
                playerControls
                Spacer()
            }.alert(isPresented: Binding(
                get: { store.error != nil },
                set: { value in store.send(.view(.tryAgainTapped))}
            ), error: store.error, actions: {})
        }
    }
    
    var cover: some View {
        ZStack {
            SkeletonView { Rectangle() }
            AsyncImage(url: URL(string: store.playItem.coverURL)) { phase in
                if let image = phase.image {
                    image
                        .resizable()
                        .scaledToFill()
                }
            }
        }
    }
    
    var keyPointNumber: some View {
        Text("Key point \(store.keyPoints.currentNumber) of \(store.keyPoints.count)")
            .textCase(.uppercase)
            .foregroundColor(.gray) // TODO: maybe use same colors from design
            .font(.footnote)
            .fontWeight(.bold)
    }
    
    var chapterTitle: some View {
        Text(store.playItem.keyPointTitle)
            .font(.subheadline)
            .foregroundColor(.black)
            .multilineTextAlignment(.center)
            .frame(height: 40)
            .padding(.horizontal, 40)
    }
    
    var slider: some View {
        HStack(spacing: 0) {
            Text(store.player.currentTime.timeString)
                .frame(width: 60)
            Slider(
                value: Binding(
                    get: { store.player.currentTime },
                    set: { value in store.send(.player(.setTime(value))) }
                ),
                in: 0...store.player.duration
            )
            
            Text(store.player.duration.timeString)
                .frame(width: 60)
        }
        .font(.footnote)
        .foregroundColor(.gray)
    }
    
    var speedLabel: some View {
        Text("\(store.player.playRate.rawValue.formattedString)x speed")
            .font(.footnote)
            .foregroundColor(.black)
            .fontWeight(.semibold)
            .padding(10)
            .background(
                RoundedRectangle(cornerRadius: 7)
                    .fill(Color.playSpeedLabel)
            )
            .onTapGesture {
                store.send(.view(.speedLabelTapped))
            }
    }
    
    var playerControls: some View {
        HStack(spacing: 30) {
            control(image: "backward.end.fill", height: Const.Controls.moveHeight) {
                store.send(.view(.backwardTapped))
            }
            .foregroundColor(store.keyPoints.isFirstKeyPoint ? .disabledControl : .black)
            .disabled(store.keyPoints.isFirstKeyPoint)
            
            control(image: "gobackward.5", height: Const.Controls.windHeigt) {
                store.send(.view(.fiveSecondsBackwardTapped))
            }
            .foregroundColor(.black) // TODO: move to button style
            
            control(image: store.player.isPlaying ? "pause.fill" : "play.fill", height: Const.Controls.playHeight) {
                store.send(.view(store.player.isPlaying ? .stopTapped : .startTapped))
            }
            .foregroundColor(.black) // TODO: move to button style
            
            control(image: "goforward.10", height: Const.Controls.windHeigt) {
                store.send(.view(.tenSecondsForwardTapped))
            }
            .foregroundColor(.black) // TODO: move to button style
            
            control(image: "forward.end.fill", height: Const.Controls.moveHeight) {
                store.send(.view(.forwardTapped))
            }
            .foregroundColor(store.keyPoints.isLastKeyPoint ? .disabledControl : .black)
            .disabled(store.keyPoints.isLastKeyPoint)
        }
    }
    
    private func control(image: String,
                         height: CGFloat,
                         action: @escaping () -> Void) -> some View {
        Button(action: action, label: {
            Image(systemName: image)
                .resizable()
                .aspectRatio(contentMode: .fit)
        })
        .buttonStyle(PlayerControlButtonStyle(height: height))
    }
}

extension KeyPointsPlayerView {
    enum Const {
        enum Cover {
            /// to match the design (real app), the proportion of the picture (height/width) was calculated
            static let sizeProporion = 1.5
            /// according to designs (real app), the picture should occupy half of the screen horizontally
            static let horizontalPartOfScreen = 0.5
            static let bottomPadding: CGFloat = 40
            static let topPadding: CGFloat = 30
        }
        
        enum KeyPointNumber {
            static let bottomPadding: CGFloat = 30
        }
        
        enum ChapterTitle {
            static let bottomPadding: CGFloat = 25
        }
        
        enum Slider {
            static let bottomPadding: CGFloat = 22
        }
        
        enum SpeedLabel {
            static let bottomPadding: CGFloat = 55
        }
        
        enum Controls {
            static let playHeight: CGFloat = 30
            static let moveHeight: CGFloat = 20
            static let windHeigt: CGFloat = 30
        }
    }
}

#Preview {
    KeyPointsPlayerView(
        store: Store(initialState: BookSummarizer.State()) {
            BookSummarizer()
        }
    )
}
