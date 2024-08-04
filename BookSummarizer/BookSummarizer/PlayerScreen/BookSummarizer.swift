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
    @Dependency(\.continuousClock) var clock
    @Dependency(\.summarizerDataSource) var dataSource
    @Dependency(\.player) var player
    
    @ObservableState
    struct State {
        struct PlayerState {
            var isPlaying: Bool = false
            var currentTime: Double = 0
            var duration: Double = 0
            var playRate: Float = 0
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
            case updateState
        }
        
        enum PlayerAction {
            case setupPlayer(_ url: URL?)
//            case setTime(_ newTime: Double)
        }
        
        enum TimerAction {
            case setupTimer
            case cancelTimer
            case timerTicked
        }
        
        case view(ViewAction)
        case dataSource(DataSourceAction)
        case player(PlayerAction)
        case timer(TimerAction)
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
                
            case .timer(let action):
                return handleTimer(action: action, with: &state)
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
//            set player.playRate
            player.play()
            state.player.duration = player.duration
            state.player.isPlaying = true
            return .run { send in
                await send(.timer(.setupTimer))
            }
        case .stopTapped:
            player.pause()
            state.player.isPlaying = false
            return .run { send in
                await send(.timer(.cancelTimer))
            }
            
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
    
    private func handleTimer(action: Action.TimerAction, with state: inout State) -> Effect<Action> {
        switch action {
        case .setupTimer:
            return setupTimer(&state)
        case .timerTicked:
            timerTicked(&state)
            return .none
        case .cancelTimer:
            return cancelTimer(&state)
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
        } catch {
//            return .send(.playerSetupFailed(error as? AudioPlayerError))
        }
    }
    
    private func setupTimer(_ state: inout State) -> Effect<Action> {
        guard state.player.isPlaying else { return .none }
        let millisecondsInterval = Int(1000.0 / 1)
        return .run { send in
            for await _ in self.clock.timer(interval: .milliseconds(millisecondsInterval)) {
                await send(.timer(.timerTicked))
            }
        }.cancellable(id: CancelID.timer)
    }
    
    private func timerTicked(_ state: inout State) {
        state.player.currentTime = player.currentTime
        state.player.isPlaying = player.isPlaying
    }
    
    private func cancelTimer(_ state: inout State) -> Effect<Action> {
        state.player.currentTime = player.currentTime
        return .cancel(id: CancelID.timer)
    }
    
    enum CancelID {
        case timer
    }
}

extension Double {
    var timeString: String {
        let minute = Int(self) / 60
        let seconds = Int(self) % 60
        return String(format: "%02d:%02d", minute, seconds)
    }
}

enum AudioSpeed: Float, CaseIterable {
    case half = 0.5
    case threeQuarters = 0.75
    case normal = 1
    case oneQuarter = 1.25
    case oneHalf = 1.5
    case oneThreeQuarters = 1.75
    case double = 2
    
    func next() -> Self {
        guard let idx = AudioSpeed.allCases.firstIndex(of: self) else {
            return .normal
        }
        let nextIdx = idx + 1
        return AudioSpeed.allCases.indices.contains(nextIdx) ? AudioSpeed.allCases[nextIdx] : .half
    }
}
