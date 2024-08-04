//
//  PlayItemFetcher.swift
//  BookSummarizer
//
//  Created by Yefremova on 03.08.2024.
//

import Foundation

protocol PlayItemFetching {
    func fetchPlayItem() async throws -> PlayItem
}
