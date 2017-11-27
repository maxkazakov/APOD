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



/// Актуализировать верхнюю часть списка
struct RefreshPicturesAction: Action {
}



//struct LoadedToBeginPicturesSuccessAction: Action {
//    let pictures: [PictureViewModel]
//}

struct LoadedPicturesSuccessAction: Action {
    let pictures: [PictureViewModel]
}

struct LoadedPicturesFailureAction: Action {
    let error: Error
}
