//
//  PictureState.swift
//  ASOD
//
//  Created by Максим Казаков on 11/11/2017.
//  Copyright © 2017 Максим Казаков. All rights reserved.
//

import Foundation




struct PictureListState {
    let loading: LoadingState        
    
    let error: Error?
    
    let pictures: [PictureViewModel]
}
