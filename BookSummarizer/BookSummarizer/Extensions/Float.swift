//
//  Float.swift
//  BookSummarizer
//
//  Created by Yefremova on 05.08.2024.
//

import Foundation

extension Float {
    var formattedString: String {
        return truncatingRemainder(dividingBy: 1) == 0 ? String(format: "%.0f", self) : String(self)
    }
}
