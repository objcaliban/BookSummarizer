//
//  DirectionButton.swift
//  BookSummarizer
//
//  Created by Yefremova on 05.08.2024.
//

import SwiftUI

struct DirectionButton: View {
    enum Direction {
        case forward, backward
        var systemImage: String {
            switch self {
            case .forward:
                "arrow.right"
            case .backward:
                "arrow.left"
            }
        }
    }
    let direction: Direction
    let height: CGFloat
    let action: () -> Void
    
    var body: some View {
        Button(action: action, label: {
            Image(systemName: direction.systemImage)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .foregroundColor(.black)
                .frame(width: height, height: height)
                .background {
                    RoundedRectangle(cornerRadius: 2)
                        .fill(.gray)
                        .opacity(0.1)
                        .scaleEffect(3)
                }
        })
    }
}
