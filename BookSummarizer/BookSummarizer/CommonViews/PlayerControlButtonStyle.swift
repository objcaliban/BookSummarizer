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
            .scaleEffect(configuration.isPressed ? 0.9 : 1)
            .background {
                Circle()
                    .fill(.gray)
                    .opacity(configuration.isPressed ? 0.2 : 0)
                    .scaleEffect(configuration.isPressed ? 1.6 : 1.8)
            }
    }
}
