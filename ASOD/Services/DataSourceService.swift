//
//  NetworkService.swift
//  ASOD
//
//  Created by Максим Казаков on 09/11/2017.
//  Copyright © 2017 Максим Казаков. All rights reserved.
//

import Foundation
import RealmSwift


enum LoadingPictureResult {
    case loaded([PictureViewModel])
    case error(Error)
}



class DataSourceService {
    static let shared = DataSourceService()
    
    func loadPictures(from date: Date?, portionSize: Int, completion: @escaping (LoadingPictureResult) -> Void) {
        let date = date?.getDateFor(days: -1) ?? Date()        
        
        // try from cache
        databaseService.load(from: date, portionSize: portionSize) { pictures in
            let viewModels = pictures.map { PictureViewModel(from: $0)}
            let cachedCount = viewModels.count
            
            if cachedCount == portionSize {
                print("All loaded from cache")
                completion(.loaded(viewModels))
                return
            }
            
            // cache misses
            let missedCount = portionSize - cachedCount
            let lastDate = viewModels.last?.date.getDateFor(days: -1) ?? date
            print("\(missedCount) missed, \(cachedCount) loaded from cache")
            
            // try load from network
            networkService.loadPictures(from: lastDate, portionSize: missedCount) { error, pictures in
                if let error = error {
                    completion(.error(error))
                    return
                }
                // save cache
                if let pictures = pictures {
                    self.databaseService.save(pictures: pictures)
                }
                let viewModels = pictures!.map { PictureViewModel(from: $0)}
                completion(.loaded(viewModels))
            }
        }
    }
    
    
    // MARK: -Private
    
    private let networkService = NetworkApiService()
    private let databaseService = DataBaseService()
}
