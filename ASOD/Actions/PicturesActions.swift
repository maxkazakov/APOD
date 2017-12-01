//
//  PictureListAction.swift
//  ASOD
//
//  Created by Максим Казаков on 12/11/2017.
//  Copyright © 2017 Максим Казаков. All rights reserved.
//

import Foundation
import ReSwift

/// Подгрузить картинки
struct LoadMorePicturesAction: Action {
    let portionSize: Int
}

struct LoadMorePicturesSuccessAction: Action {
    let pictures: [PictureViewModel]
}


struct LoadMorePicturesFailureAction: Action {
    let error: Error
}



/// Актуализировать верхнюю часть списка
struct RefreshPicturesAction: Action {
}


struct RefreshPicturesSuccessAction: Action {
    let pictures: [PictureViewModel]
}


struct RefreshPicturesFailureAction: Action {
    let error: Error
}


struct StopRefreshPicturesAction: Action {
    
}
