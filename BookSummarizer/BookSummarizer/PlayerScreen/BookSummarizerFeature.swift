//
//  BookSummarizerFeature.swift
//  BookSummarizer
//
//  Created by Yefremova on 01.08.2024.
//

import ComposableArchitecture
import Foundation

@Reducer
struct BookSummarizerFeature {
    private protocol BookSummarizerAction {
        associatedtype ViewAction
        
        static func view(_:ViewAction) -> Self
    }
    
    @ObservableState
    struct State {
        var isAudioPlaying = false
        var coverURL: URL?
//        var title = ""
    }
    
    enum Action: BookSummarizerAction {
        enum ViewAction {
            case startTapped
            case stopTapped
            case forwardTapped
            case backwardTapped
        }
        
        case view(ViewAction)
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .view(let action):
                return handleView(action: action, with: &state)
            }
        }
    }
    
    private func handleView(action: Action.ViewAction, with state: inout State) -> Effect<Action> {
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
