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
            var playRate: PlayRate = .normal
        }
        
        struct PlayItemViewState {
            var coverURL: String = ""
            var keyPointTitle: String = ""
        }
        
        struct KeyPointsState {
            var currentNumber: Int = 0
            var count: Int = 0
            var isFirstKeyPoint: Bool = false
            var isLastKeyPoint: Bool = false
        }
        
        struct KeyPointReaderState {
            var title: String = ""
            var text: String = ""
        }
        
        var isErrorAppeared = false
        var error: SummarizerError?
        var isLoading = true
        var player = PlayerState()
        var playItem = PlayItemViewState()
        var keyPoints = KeyPointsState()
        var keyPointReader = KeyPointReaderState()
    }
    
    enum Action {
        enum ViewAction {
            case setupInitiated
            case startTapped
            case stopTapped
            case forwardTapped
            case backwardTapped
            case tenSecondsForwardTapped
            case fiveSecondsBackwardTapped
            case speedLabelTapped
            case tryAgainTapped
        }
        
        enum DataSourceAction {
            case setupDataSource
            case updateState
        }
        
        enum PlayerAction {
            case setupPlayer
            case play
            case setTime(_ time: Double)
            case moveTenSecondsForward
            case moveFiveSecondsBackward
            case moveForward
            case moveBackward
            case changePlayRate
            case handlePlayingFinish
            case updateDuration
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
}

// MARK: UI actions
extension BookSummarizer {
    // TODO: maybe add subreducers
    private func handleView(action: Action.ViewAction, with state: inout State) -> Effect<Action> {
        switch action {
        case .setupInitiated:
            return .run { send in
                await send(.dataSource(.setupDataSource))
            }
        case .startTapped:
            //            set player.playRate
            return .run { send in
                await send(.player(.play))
            }
        case .stopTapped:
            stopPlayer(&state)
            return .run { send in
                await send(.timer(.cancelTimer))
            }
            
        case .forwardTapped:
            return .send(.player(.moveForward))
            
        case .backwardTapped:
            return .send(.player(.moveBackward))
            
        case .tenSecondsForwardTapped:
            return .send(.player(.moveTenSecondsForward))
            
        case .fiveSecondsBackwardTapped:
            return .send(.player(.moveFiveSecondsBackward))
            
        case .speedLabelTapped:
            return .send(.player(.changePlayRate))
        case .tryAgainTapped:
            return .send(.dataSource(.setupDataSource))
        }
    }
}

// MARK: DataSource methods
extension BookSummarizer {
    private func handleDataSource(action: Action.DataSourceAction, with state: inout State) -> Effect<Action> {
        switch action {
        case .setupDataSource:
            return .run { send in
                await dataSource.setupDataSource()
                await send(.player(.setupPlayer))
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
            state.error = LocalizedErrorAdapter.shared.adapt(error: dataSource.accuredError)
            return
        }
        handleBorderKeyPoints(&state)
        state.playItem.coverURL = playItem.cover
        state.playItem.keyPointTitle = keyPoint.title
        state.keyPoints.currentNumber = keyPoint.number
        state.keyPoints.count = playItem.keyPoints.count
        
        state.keyPointReader.title = keyPoint.title
        state.keyPointReader.text = keyPoint.text
    }
    
    private func handleBorderKeyPoints(_ state: inout State) {
        state.keyPoints.isFirstKeyPoint = dataSource.isFirstKeyPoint
        state.keyPoints.isLastKeyPoint = dataSource.isLastKeyPoint
    }
}

// MARK: Player methods
extension BookSummarizer {
    private func handlePlayer(action: Action.PlayerAction, with state: inout State) -> Effect<Action> {
        switch action {
        case .setupPlayer:
            setupPlayer(&state)
            return .run { send in
                await send(.dataSource(.updateState))
            }
            
        case .play:
            player.play()
            state.player.duration = player.duration
            state.player.isPlaying = true
            return .run { send in
                await send(.timer(.setupTimer))
            }
        case .setTime(let time):
            setPlayerTime(&state, time: time)
            return .none
            
        case .moveTenSecondsForward:
            let updatedTime = state.player.currentTime + 10
            return .send(.player(.setTime(updatedTime <= state.player.duration ? updatedTime : state.player.duration)))
            
        case .moveFiveSecondsBackward:
            let updatedTime = state.player.currentTime - 5
            return .send(.player(.setTime(updatedTime >= 0 ? updatedTime : 0)))
        
        case .moveForward:
            dataSource.moveToNextKeyPoint()
            return updatePlayer(&state)
            
        case .moveBackward:
            dataSource.moveToPreviousKeyPoint()
            return updatePlayer(&state)
            
        case .changePlayRate:
            state.player.playRate = state.player.playRate.next()
            player.playRate = state.player.playRate.rawValue
            return .none
            
        case .handlePlayingFinish:
            stopPlayer(&state)
            return .run { send in
                await send(.player(.moveForward))
            }
        case .updateDuration:
            state.player.duration = player.duration
            return .none
        }
    }
    
    private func updatePlayer(_ state: inout State) -> Effect<Action> {
        update(state: &state)
        return .run { send in
            await dataSource.setupDataSource()
            await send(.player(.setupPlayer))
        }
    }
    
    private func setPlayerTime(_ state: inout State, time: Double) {
        player.currentTime = time
        state.player.currentTime = time
    }
    
    private func stopPlayer(_ state: inout State) {
        player.pause()
        state.player.isPlaying = false
    }
    
    private func resetPlayer(_ state: inout State) {
        stopPlayer(&state)
        state.player.currentTime = 0
    }
    
    private func setupPlayer(_ state: inout State) {
        do {
            resetPlayer(&state)
            let url = URL(string: dataSource.currentKeyPoint?.audioURL ?? "")
            try player.setup(with: url)
        } catch {
            state.isErrorAppeared = true
            state.error = LocalizedErrorAdapter.shared.adapt(error: error)
        }
    }
}

// MARK: Timer methods
extension BookSummarizer {
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
