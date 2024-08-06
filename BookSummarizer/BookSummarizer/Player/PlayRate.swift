//
//  PlayRate.swift
//  BookSummarizer
//
//  Created by Yefremova on 04.08.2024.
//

import Foundation

enum PlayRate: Float, CaseIterable, Equatable {
    case half = 0.5
    case threeQuarters = 0.75
    case normal = 1
    case oneQuarter = 1.25
    case oneHalf = 1.5
    case oneThreeQuarters = 1.75
    case double = 2
    
    func next() -> Self {
        guard let idx = PlayRate.allCases.firstIndex(of: self) else {
            return .normal
        }
        let nextIdx = idx + 1
        return PlayRate.allCases.indices.contains(nextIdx) ? PlayRate.allCases[nextIdx] : .half
    }
}
