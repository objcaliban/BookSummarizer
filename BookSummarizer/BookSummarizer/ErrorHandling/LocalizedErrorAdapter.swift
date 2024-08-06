//
//  LocalizedErrorAdapter.swift
//  BookSummarizer
//
//  Created by Yefremova on 05.08.2024.
//

import Foundation

/// created to save time
struct LocalizedErrorAdapter {
    static let shared = LocalizedErrorAdapter()
    
    private init() {}
    
    func adapt(error: Error?) -> SummarizerError {
        guard let error = error as? SummarizerError else {
            return SummarizerError.undefinedError
        }
        return error
    }
}

