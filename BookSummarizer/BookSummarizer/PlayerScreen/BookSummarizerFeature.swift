//
//  BookSummarizerFeature.swift
//  BookSummarizer
//
//  Created by Yefremova on 01.08.2024.
//

import ComposableArchitecture

@Reducer
struct BookSummarizerFeature {
    @ObservableState
    struct State {
        var isAudioPlaying = false
    }
    
    enum Action {
        case startTapped
        case stopTapped
        case forwardTapped
        case backwardTapped
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .startTapped:
                state.isAudioPlaying = true
                return .none
                
            case .stopTapped:
                state.isAudioPlaying = false
                return .none
                
            case .forwardTapped:
                return .none
                
            case .backwardTapped:
                return .none
            }
        }
    }
}
