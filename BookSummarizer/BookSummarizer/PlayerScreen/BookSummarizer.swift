//
//  BookSummarizerFeature.swift
//  BookSummarizer
//
//  Created by Yefremova on 01.08.2024.
//

import ComposableArchitecture
import Foundation

@Reducer
struct BookSummarizer {
    @Dependency(\.playItemFetcher) var playItemFetcher
    
    @ObservableState
    struct State {
        struct PlayerState {
            var isAudioPlaying = false
            var currentTime: TimeInterval = 0
            var duration: TimeInterval = 0
        }
        
        struct CoverState {
            var isErrorAppeared = false
            var coverURL: URL? = URL(string: "https://m.media-amazon.com/images/I/713AIrfxlqL._AC_UF1000,1000_QL80_.jpg") // TODO: remove mock
        }
        
        
        var isLoading = true
        var player = PlayerState()
        var cover = CoverState()
    }
    
    enum Action {
        enum ViewAction {
            case setupInitiated
            case startTapped
            case stopTapped
            case forwardTapped
            case backwardTapped
        }
        
        enum NetworkAction {
            case requestPlayItem
        }
        
        case view(ViewAction)
        case network(NetworkAction)
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .view(let action):
                return handleView(action: action, with: &state)
                
            case .network(let action):
                return handleNetwok(action: action, with: &state)
            }
        }
    }
    
        // TODO: maybe add subreducers
    private func handleView(action: Action.ViewAction, with state: inout State) -> Effect<Action> {
        switch action {
        case .setupInitiated:
            return .run { send in
                await send(.network(.requestPlayItem))
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
    private func handleNetwok(action: Action.NetworkAction, with state: inout State) -> Effect<Action> {
        switch action {
        case .requestPlayItem:
            return .run { send in
                do {
                    /// if this were a real application, here I would be able to make a request to receive the book
                    /// for example, I made a request and received a book
                    let playItem = try await playItemFetcher.fetchPlayItem()
                    print(playItem)
                } catch {
                    print(error.localizedDescription)
                }
            }
        }
    }
}


