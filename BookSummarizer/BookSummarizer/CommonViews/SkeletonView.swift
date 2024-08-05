//
//  SkeletonView.swift
//  BookSummarizer
//
//  Created by Yefremova on 05.08.2024.
//

import SwiftUI

struct SkeletonView<Content>: View where Content: Shape {
    let content: Content

    @State private var gradientOffset: CGFloat = -1
    @State private var gradientOpacity: Double = 0.3

    private var gradientColors: [Color] = [
        Color.skeletonStart,
        Color.skeletonEnd
    ]

    public init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    var body: some View {
        content
            .fill(gradientFill)
            .opacity(gradientOpacity)
            .onAppear {
                animateGradient()
            }
    }

    private var gradientFill: LinearGradient {
        LinearGradient(
            gradient: Gradient(colors: gradientColors),
            startPoint: UnitPoint(x: gradientOffset, y: 0),
            endPoint: UnitPoint(x: gradientOffset + 0.5, y: 0)
        )
    }

    private func animateGradient() {
        withAnimation(
            Animation
                .easeInOut(duration: 1.5)
                .repeatForever(autoreverses: true)
        ) {
            gradientOffset = 1
            gradientOpacity = 0.7
        }
    }
}

#Preview {
    SkeletonView { Rectangle() }
}
