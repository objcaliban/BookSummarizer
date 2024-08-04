//
//  Double.swift
//  BookSummarizer
//
//  Created by Yefremova on 04.08.2024.
//

import Foundation

extension Double {
    var timeString: String {
        let minute = Int(self) / 60
        let seconds = Int(self) % 60
        return String(format: "%02d:%02d", minute, seconds)
    }
}
