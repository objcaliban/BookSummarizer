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
                    .cornerRadius(Const.Cover.cornerRadius)
                    .padding(.bottom, Const.Cover.bottomPadding)
                    .padding(.top, Const.Cover.topPadding)
                keyPointNumber
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
        Text(String(format: Const.KeyPointNumber.titleMask,
                    store.keyPoints.currentNumber, store.keyPoints.count))
            .textCase(.uppercase)
            .foregroundColor(.gray)
            .font(.footnote)
            .fontWeight(.semibold)
    }
    
    var chapterTitle: some View {
        Text(store.playItem.keyPointTitle)
            .font(.subheadline)
            .fontWeight(.light)
            .foregroundColor(.black)
            .multilineTextAlignment(.center)
            .frame(height: Const.ChapterTitle.height)
            .padding(.horizontal, Const.ChapterTitle.horisontalPadding)
    }
    
    var slider: some View {
        HStack(spacing: 0) {
            Text(store.player.currentTime.timeString)
                .frame(width: Const.Slider.timeTitleWidth)
            Slider(
                value: Binding(
                    get: { store.player.currentTime },
                    set: { value in store.send(.player(.setTime(value))) }
                ),
                in: 0...store.player.duration
            )
            
            Text(store.player.duration.timeString)
                .frame(width: Const.Slider.timeTitleWidth)
        }
        .font(.footnote)
        .foregroundColor(.gray)
    }
    
    var speedLabel: some View {
        Text(String(format: Const.SpeedLabel.titleMask,
                    store.player.playRate.rawValue.formattedString))
            .font(.footnote)
            .foregroundColor(.black)
            .fontWeight(.semibold)
            .padding(Const.SpeedLabel.internalPadding)
            .background(
                RoundedRectangle(cornerRadius: Const.SpeedLabel.cornerRadius)
                    .fill(Color.playSpeedLabel)
            )
            .onTapGesture {
                store.send(.view(.speedLabelTapped))
            }
    }
    
    var playerControls: some View {
        HStack(spacing: Const.Controls.spacings) {
            control(image: "backward.end.fill", height: Const.Controls.moveHeight) {
                store.send(.view(.backwardTapped))
            }
            .foregroundColor(store.keyPoints.isFirstKeyPoint ? .disabledControl : .black)
            .disabled(store.keyPoints.isFirstKeyPoint)
            
            control(image: "gobackward.5", height: Const.Controls.windHeigt) {
                store.send(.view(.fiveSecondsBackwardTapped))
            }
            .foregroundColor(.black)
            
            control(image: store.player.isPlaying ? "pause.fill" : "play.fill", height: Const.Controls.playHeight) {
                store.send(.view(store.player.isPlaying ? .stopTapped : .startTapped))
            }
            .foregroundColor(.black)
            
            control(image: "goforward.10", height: Const.Controls.windHeigt) {
                store.send(.view(.tenSecondsForwardTapped))
            }
            .foregroundColor(.black)
            
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
            
            static let cornerRadius: CGFloat = 10
        }
        
        enum KeyPointNumber {
            static let bottomPadding: CGFloat = 5
            static let titleMask = "Key point %d of %d"
        }
        
        enum ChapterTitle {
            static let height: CGFloat = 40
            static let bottomPadding: CGFloat = 25
            static let horisontalPadding: CGFloat = 20
        }
        
        enum Slider {
            static let bottomPadding: CGFloat = 5
            static let timeTitleWidth: CGFloat = 60
        }
        
        enum SpeedLabel {
            static let bottomPadding: CGFloat = 55
            static let titleMask = "%@x speed"
            static let internalPadding: CGFloat = 10
            static let cornerRadius: CGFloat = 7
        }
        
        enum Controls {
            static let spacings: CGFloat = 30
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
