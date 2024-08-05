//
//  SummarizerError.swift
//  BookSummarizer
//
//  Created by Yefremova on 05.08.2024.
//

import Foundation

/// in a real project, I would not create one enum for all errors. made to save time
enum SummarizerError: LocalizedError {
    case undefinedError
    case invalidUrl
    case dataCorrupted
    
    var errorDescription: String? {
        switch self {
        case .undefinedError:
            return "Something went wrong"
        case .invalidUrl:
            return "Invalid URL"
        case .dataCorrupted:
            return "Data Corrupted"
        }
    }
}
