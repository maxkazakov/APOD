//
//  PicturesReducer.swift
//  ASOD
//
//  Created by Максим Казаков on 12/11/2017.
//  Copyright © 2017 Максим Казаков. All rights reserved.
//

import ReSwift

func appReducer(action: Action, state: AppState?) -> AppState {
    return AppState(
        picturesList: picturesReducer(state: state?.picturesList, action: action),
        selectedPicture: selectedPictureReducer(state: state?.selectedPicture, action: action)
    )
}


