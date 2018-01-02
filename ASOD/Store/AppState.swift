//
//  AppState.swift
//  ASOD
//
//  Created by Максим Казаков on 11/11/2017.
//  Copyright © 2017 Максим Казаков. All rights reserved.
//

import Foundation
import ReSwift

enum LoadingState {
    case none
    case loadingMore
    case refreshing
}



struct AppState: StateType {
    let picturesList: PictureListState
    let selectedPicture: SelectedPictureState
}

