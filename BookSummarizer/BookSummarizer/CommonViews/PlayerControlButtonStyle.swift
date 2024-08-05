//
//  ControlButtonStyle.swift
//  BookSummarizer
//
//  Created by Yefremova on 05.08.2024.
//

import SwiftUI

struct PlayerControlButtonStyle: ButtonStyle {
    let height: CGFloat
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(width: height, height: height)
            .animation(nil, value: UUID())
            .scaleEffect(configuration.isPressed ? Const.Button.animationScale : Const.Button.normalScale)
            .background {
                Circle()
                    .fill(.gray)
                    .opacity(configuration.isPressed ? Const.Background.animationOpacity : Const.Background.normalOpacity)
                    .scaleEffect(configuration.isPressed ? Const.Background.animationScale : Const.Background.normalScale)
            }
    }
}

extension PlayerControlButtonStyle {
    enum Const {
        enum Button {
            static let animationScale: CGFloat = 0.9
            static let normalScale: CGFloat = 1
        }
        
        enum Background {
            static let animationScale: CGFloat = 1.6
            static let normalScale: CGFloat = 1.8
            
            static let animationOpacity: CGFloat = 0.2
            static let normalOpacity: CGFloat = 0
        }
    }
}
