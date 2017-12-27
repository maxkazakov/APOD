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
        
    case let success as LoadMorePicturesSuccessAction:
        let pictures = (success.pictures + state.pictures).sorted { $0.date > $1.date }
        return PicturesState(loading: .none, error: nil, pictures: pictures)
        
    case let failure as LoadMorePicturesFailureAction:
        return PicturesState(loading: .none, error: failure.error, pictures: state.pictures)
    
    case let success as RefreshPicturesSuccessAction:
        let pictures = (success.pictures + state.pictures).sorted { $0.date > $1.date }
        return PicturesState(loading: .none, error: nil, pictures: pictures)
        
    case let failure as RefreshPicturesFailureAction:
        return PicturesState(loading: .none, error: failure.error, pictures: state.pictures)
    
    case _ as StopRefreshPicturesAction:
        return PicturesState(loading: .none, error: nil, pictures: state.pictures)
        
    
    default:
        return state
    }
}



fileprivate func initPictureState() -> PicturesState {
    return PicturesState(loading: .none, error: nil, pictures: [])
}

