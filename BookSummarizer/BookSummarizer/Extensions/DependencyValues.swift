//
//  DependencyValues.swift
//  BookSummarizer
//
//  Created by Yefremova on 03.08.2024.
//

import Dependencies

extension DependencyValues {
  var playItemFetcher: PlayItemFetching {
    get { self[PlayItemFetchingKey.self] }
    set { self[PlayItemFetchingKey.self] = newValue }
  }
}

private enum PlayItemFetchingKey: DependencyKey {
    static var liveValue: PlayItemFetching = mock
    
    static let mock: PlayItemFetching = JSONKeeper()
}

