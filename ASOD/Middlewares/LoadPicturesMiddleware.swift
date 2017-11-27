//
//  LoadingPicturesMiddleware.swift
//  ASOD
//
//  Created by Максим Казаков on 13/11/2017.
//  Copyright © 2017 Максим Казаков. All rights reserved.
//


import ReSwift

let loadPicturesMiddleware: Middleware<AppState> = { dispatch, getState in
    return { next in
        return { action in
            guard let loadAction = action as? LoadMorePicturesAction else {
                return next(action)
            }
            let state = getState()!
            let date = state.picturesState.pictures.last?.date ?? nil
            
            DataSourceService.shared.loadPictures(from: date, portionSize: loadAction.portionSize) { result in
                DispatchQueue.main.async {
                    switch result {
                    case .loaded(let pictures):
                        dispatch(LoadedPicturesSuccessAction(pictures: pictures))
                    case .error(let error):
                        dispatch(LoadedPicturesFailureAction(error: error))
                    }
                }                
            }
            return next(action)
        }
    }
}
