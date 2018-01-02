//
//  PicturesListReducer.swift
//  ASOD
//
//  Created by Максим Казаков on 12/11/2017.
//  Copyright © 2017 Максим Казаков. All rights reserved.
//

import ReSwift

func picturesReducer(state: PictureListState?, action: Action) -> PictureListState {
    
    func initState() -> PictureListState {
        return PictureListState(loading: .none, error: nil, pictures: [])
    }
    
    
    let state = state ?? initState()

    switch action {
    case _ as LoadMorePicturesAction:
        return PictureListState(loading: .loadingMore, error: nil, pictures: state.pictures)
        
    case _ as RefreshPicturesAction:
        return PictureListState(loading: .refreshing, error: nil, pictures: state.pictures)
        
    case let success as LoadMorePicturesSuccessAction:
        let pictures = (success.pictures + state.pictures).sorted { $0.date > $1.date }
        return PictureListState(loading: .none, error: nil, pictures: pictures)
        
    case let failure as LoadMorePicturesFailureAction:
        return PictureListState(loading: .none, error: failure.error, pictures: state.pictures)
    
    case let success as RefreshPicturesSuccessAction:
        let pictures = (success.pictures + state.pictures).sorted { $0.date > $1.date }
        return PictureListState(loading: .none, error: nil, pictures: pictures)
        
    case let failure as RefreshPicturesFailureAction:
        return PictureListState(loading: .none, error: failure.error, pictures: state.pictures)
    
    case _ as StopRefreshPicturesAction:
        return PictureListState(loading: .none, error: nil, pictures: state.pictures)
        
    
    default:
        return state
    }
}



func selectedPictureReducer(state: SelectedPictureState?, action: Action) -> SelectedPictureState {    
    func initState() -> SelectedPictureState {
        return SelectedPictureState(picture: nil)
    }
    
    let state = state ?? initState()
    
    switch action {
    case let action as SelectPicturesAction:
        return SelectedPictureState(picture: action.picture)
    default:
        return state
    }
}


