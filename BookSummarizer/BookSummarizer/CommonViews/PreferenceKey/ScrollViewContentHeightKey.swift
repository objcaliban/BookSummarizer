//
//  ScrollViewContentHeightKey.swift
//  BookSummarizer
//
//  Created by Yefremova on 06.08.2024.
//

import SwiftUI

struct ScrollViewContentHeightKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}
