//
//  LoadingPicturesMiddleware.swift
//  ASOD
//
//  Created by Максим Казаков on 13/11/2017.
//  Copyright © 2017 Максим Казаков. All rights reserved.
//


import ReSwift

let loadMorePicturesMiddleware: Middleware<AppState> = { dispatch, getState in
    return { next in
        return { action in
            guard let loadAction = action as? LoadMorePicturesAction else {
                return next(action)
            }
            let state = getState()!
            
            let lastDate = state.picturesState.pictures.last?.date ?? nil
            let date = lastDate?.getDateFor(days: -1) ?? Date().withoutTime().getDateFor(days: -13)!
            var dates = [Date]()
            for i in 0...(loadAction.portionSize - 1) {
                dates.append(date.getDateFor(days: -i)!)
            }
            
            DataSourceService.shared.loadPictures(dates: dates) { result in
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


let refreshPicturesMiddleware: Middleware<AppState> = { dispatch, getState in
    return { next in
        return { action in
            guard let loadAction = action as? RefreshPicturesAction else {
                return next(action)
            }
            let state = getState()!
            
            let today = Date().withoutTime()
            let firstActualDate = state.picturesState.pictures.first?.date ?? nil
            let portionSize = firstActualDate.map { today.daysOffset(from: $0) } ?? 5
            if portionSize == 0 {
                next(action)
                dispatch(StopRefreshingPicturesAction())
                return
            }
            
            var dates = [Date]()
            for i in 0...(portionSize - 1) {
                dates.append(today.getDateFor(days: -i)!)
            }
            
            DataSourceService.shared.loadPictures(dates: dates) { result in
                DispatchQueue.main.async {
                    switch result {
                    case .loaded(let pictures):
                        dispatch(RefreshedPicturesSuccessAction(pictures: pictures))
                    case .error(let error):
                        dispatch(RefreshedPicturesFailureAction(error: error))
                    }
                }
            }
            return next(action)
        }
    }
}
