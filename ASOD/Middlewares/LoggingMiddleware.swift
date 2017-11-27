//
//  LogginMiddleware.swift
//  ASOD
//
//  Created by Максим Казаков on 12/11/2017.
//  Copyright © 2017 Максим Казаков. All rights reserved.
//

import ReSwift

let loggingMiddleware: Middleware<AppState> = { dispatch, state in
    return { next in
        return { action in
            // perform middleware logic
            print(action)
            
            // call next middleware
            return next(action)
        }
    }
}
