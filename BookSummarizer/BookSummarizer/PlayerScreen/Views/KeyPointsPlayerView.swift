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
        
        // TODO: maybe change color
        let thumbImage = UIImage(systemName: "circle.fill")
        UISlider.appearance().setThumbImage(thumbImage, for: .normal)
    }
    
    var body: some View {
        VStack {
            cover
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
        }
    }
    
    var cover: some View {
        AsyncImage(url: URL(string: store.playItem.coverURL)) { phase in
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
        Text("Key point \(store.playItem.keyPointNumber) of \(store.playItem.keyPointsCount)")
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
            Text("00:00")
                .frame(width: 60)
            
            Slider(
                value: Binding(
                    get: { store.player.currentTime },
                    set: { value in }
                ),
                in: 0...store.player.duration
            )
            Text("00:00")
                .frame(width: 60)
        }
        .font(.footnote)
        .foregroundColor(.gray)
    }
    
    var speedLabel: some View {
        Text("Speed x0") // TODO: Remove mock
            .font(.footnote)
            .foregroundColor(.black)
            .fontWeight(.bold)
            .padding(10)
            .background(
                RoundedRectangle(cornerRadius: 7)
                    .fill(Color(UIColor.systemGray5)) // TODO: use design color
            )
            .onTapGesture {
                // TODO: add action
            }
    }
    
    var playerControls: some View {
        HStack(spacing: 30) {
            control(image: "backward.end.fill") {
                store.send(.view(.backwardTapped))
            }
            .frame(height: Const.Controls.moveHeight)
            .foregroundColor(.black) // TODO: move to button style
            
            control(image: "gobackward.5") {
                // TODO: add action
            }
            .frame(height: Const.Controls.windHeigt)
            .foregroundColor(.black) // TODO: move to button style
            
            control(image: store.player.isAudioPlaying ? "play.fill" : "pause.fill") {
                store.send(.view(store.player.isAudioPlaying ? .stopTapped : .startTapped))
            }
            .frame(width: Const.Controls.playHeight, height: Const.Controls.playHeight)
            .foregroundColor(.black) // TODO: move to button style
            
            control(image: "goforward.10") {
                // TODO: add action
            }
            .frame(height: Const.Controls.windHeigt)
            .foregroundColor(.black) // TODO: move to button style
            
            control(image: "forward.end.fill") {
                store.send(.view(.forwardTapped))
            }
            .frame(height: Const.Controls.moveHeight)
            .foregroundColor(.black) // TODO: move to button style
        }
    }
    
    private func control(image: String,
                         action: @escaping () -> Void) -> some View {
        Button(action: action, label: {
            Image(systemName: image)
                .resizable()
                .aspectRatio(contentMode: .fit)
            // TODO: add button style for animation
        })
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
