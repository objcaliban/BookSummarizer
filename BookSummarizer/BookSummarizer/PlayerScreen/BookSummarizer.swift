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
        
        case view(ViewAction)
        case dataSource(DataSourceAction)
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .view(let action):
                return handleView(action: action, with: &state)
                
            case .dataSource(let action):
                return handleDataSource(action: action, with: &state)
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
            state.player.isAudioPlaying = true
            return .none
        case .stopTapped:
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
                await send(.dataSource(.updateState))
            }
        case .updateState:
            update(state: &state)
            return .none
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
}
