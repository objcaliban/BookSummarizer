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
    
    var summarizerDataSource: SummarizerDataSourceInterface {
        get { self[SummarizerDataSourceKey.self] }
        set { self[SummarizerDataSourceKey.self] = newValue }
    }
    
    var player: AudioPlayer {
        get { self[AudioPlayerKey.self] }
        set { self[AudioPlayerKey.self] = newValue }
    }
    
    private enum PlayItemFetchingKey: DependencyKey {
        static var liveValue: PlayItemFetching = mock
        static let mock: PlayItemFetching = JSONKeeper()
    }
    
    private enum SummarizerDataSourceKey: DependencyKey {
        static var liveValue: SummarizerDataSourceInterface = SummarizerDataSource()
    }
    
    private enum AudioPlayerKey: DependencyKey {
        static var liveValue: AudioPlayer = AudioPlayer()
    }
}
