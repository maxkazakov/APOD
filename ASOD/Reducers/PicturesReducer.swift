//
//  PicturesListReducer.swift
//  ASOD
//
//  Created by Максим Казаков on 12/11/2017.
//  Copyright © 2017 Максим Казаков. All rights reserved.
//

import ReSwift

func picturesReducer(state: PicturesState?, action: Action) -> PicturesState {
    let state = state ?? initPictureState()

    switch action {
    case _ as LoadMorePicturesAction:
        return PicturesState(loading: .loadingMore, error: nil, pictures: state.pictures)
        
    case _ as RefreshPicturesAction:
        return PicturesState(loading: .refreshing, error: nil, pictures: state.pictures)
        
    case let success as LoadedPicturesSuccessAction:
        print("Was: \(state.pictures.count), now: \(state.pictures.count + success.pictures.count)")
        return PicturesState(loading: .none, error: nil, pictures: state.pictures + success.pictures)
        
    case let failure as LoadedPicturesFailureAction:
        return PicturesState(loading: .none, error: failure.error, pictures: state.pictures)
    
    case let success as RefreshedPicturesSuccessAction:
        print("Was: \(state.pictures.count), now: \(state.pictures.count + success.pictures.count)")
        return PicturesState(loading: .none, error: nil, pictures:  success.pictures + state.pictures)
        
    case let failure as RefreshedPicturesFailureAction:
        return PicturesState(loading: .none, error: failure.error, pictures: state.pictures)
    
    case _ as StopRefreshingPicturesAction:
        return PicturesState(loading: .none, error: nil, pictures: state.pictures)
        
    
    default:
        return state
    }
}



fileprivate func initPictureState() -> PicturesState {
    return PicturesState(loading: .none, error: nil, pictures: [])
}

