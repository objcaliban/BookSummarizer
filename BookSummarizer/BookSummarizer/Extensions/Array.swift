//
//  Array.swift
//  BookSummarizer
//
//  Created by Yefremova on 04.08.2024.
//

import Foundation

extension Array {
    /// Safely accesses the element at the specified index if it is within bounds.
    ///
    /// - Parameter index: The index of the element to access.
    /// - Returns: The element at the specified index if it is within bounds, otherwise nil.
    subscript(safe index: Int) -> Element? {
        get {
            return indices.contains(index) ? self[index] : nil
        }
        set {
            guard let newValue = newValue, indices.contains(index) else {
                print("Index out of bounds or newValue is nil")
                return
            }
            self[index] = newValue
        }
    }
}
