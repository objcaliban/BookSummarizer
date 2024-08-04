//
//  BookSummarizerFeature.swift
//  BookSummarizer
//
//  Created by Yefremova on 01.08.2024.
//

import ComposableArchitecture
import Foundation

/// possible refactoring notes:
/// - cosider adding subreducers
///  - chech notes about possibe rename
///   -
@Reducer
struct BookSummarizer {
    @Dependency(\.summarizerDataSource) var dataSource
    @Dependency(\.player) var player
    
    @ObservableState
    struct State {
        struct PlayerState {
            var isAudioPlaying = false
            var currentTime: TimeInterval = 0
            var duration: TimeInterval = 0
        }
        
        struct PlayItemViewState {
            var coverURL: String = ""
            var keyPointTitle: String = ""
            var keyPointNumber: Int = 0
            var keyPointsCount: Int = 0
        }
        
        var isErrorAppeared = false
        var isLoading = true
        var player = PlayerState()
        var playItem = PlayItemViewState()
    }
    
    enum Action {
        enum ViewAction {
            case setupInitiated
            case startTapped
            case stopTapped
            case forwardTapped
            case backwardTapped
        }
        
        enum DataSourceAction {
            case setupDataSource
            
            /// data source update handle
            case updateState
        }
        
        enum PlayerAction {
            case setupPlayer(_ url: URL?)
        }
        
        case view(ViewAction)
        case dataSource(DataSourceAction)
        case player(PlayerAction)
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .view(let action):
                return handleView(action: action, with: &state)
                
            case .dataSource(let action):
                return handleDataSource(action: action, with: &state)
                
            case .player(let action):
                return handlePlayer(action: action, with: &state)
            }
        }
    }
    
        // TODO: maybe add subreducers
    private func handleView(action: Action.ViewAction, with state: inout State) -> Effect<Action> {
        switch action {
        case .setupInitiated:
            return .run { send in
                await send(.dataSource(.setupDataSource))
            }
        case .startTapped:
            player.play()
            state.player.isAudioPlaying = true
            return .none
        case .stopTapped:
            player.pause()
            state.player.isAudioPlaying = false
            return .none
            
        case .forwardTapped:
            return .none
            
        case .backwardTapped:
            return .none
        }
    }
    
    // TODO: maybe remove state if not needed
    private func handleDataSource(action: Action.DataSourceAction, with state: inout State) -> Effect<Action> {
        switch action {
        case .setupDataSource:
            return .run { send in
                await dataSource.setupDataSource()
                let url = URL(string: dataSource.currentKeyPoint?.audioURL ?? "")
                await send(.player(.setupPlayer(url)))
            }
        case .updateState:
            update(state: &state)
            return .none
        }
    }
    
    private func handlePlayer(action: Action.PlayerAction, with state: inout State) -> Effect<Action> {
        switch action {
        case .setupPlayer(let url):
            setupPlayer(&state, with: url)
            return .run { send in
                await send(.dataSource(.updateState))
            }
        }
    }
    
    private func update(state: inout State) {
        guard let playItem = dataSource.currentPlayItem,
              let keyPoint = dataSource.currentKeyPoint else {
            state.isLoading = false
            state.isErrorAppeared = true
            return
        }
        state.playItem.coverURL = playItem.cover
        state.playItem.keyPointTitle = keyPoint.title
        state.playItem.keyPointNumber = keyPoint.number
        state.playItem.keyPointsCount = playItem.keyPoints.count
        // TODO Setup player
    }
    
    private func setupPlayer(_ state: inout State, with url: URL?) {
        do {
            try player.setup(with: url)
//            state.currentTime = player.currentTime
//            state.totalTime = player.duration
        } catch {
//            return .send(.playerSetupFailed(error as? AudioPlayerError))
        }
    }
}
