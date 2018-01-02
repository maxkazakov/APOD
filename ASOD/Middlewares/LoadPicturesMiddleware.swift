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
            
            let lastDate = state.picturesList.pictures.last?.date ?? nil
//            let date = lastDate?.getDateFor(days: -1) ?? Date().withoutTime()
            let date = lastDate?.getDateFor(days: -1) ?? Date().getDateFor(days: -4)!.withoutTime()
            var dates = [Date]()
            for i in 0...(loadAction.portionSize - 1) {
                dates.append(date.getDateFor(days: -i)!)
            }
            
            DataSourceService.loadPicturesAsync(from: dates, queue: DispatchQueue.main) { error, pictures in
                if let error = error {
                    dispatch(LoadMorePicturesFailureAction(error: error))
                    return
                }
                dispatch(LoadMorePicturesSuccessAction(pictures: pictures))
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
            let firstActualDate = state.picturesList.pictures.first?.date ?? nil
            guard let portionSize = firstActualDate.map({ today.daysOffset(from: $0) }), portionSize > 0 else {
                next(action)
                dispatch(StopRefreshPicturesAction())
                return
            }
            
            var dates = [Date]()
            for i in 0...(portionSize - 1) {
                dates.append(today.getDateFor(days: -i)!)
            }
            
            DataSourceService.loadPicturesAsync(from: dates, queue: DispatchQueue.main) { error, pictures in
                if let error = error {
                    dispatch(LoadMorePicturesFailureAction(error: error))
                    return
                }                
                dispatch(LoadMorePicturesSuccessAction(pictures: pictures))
            }
            return next(action)
        }
    }
}
