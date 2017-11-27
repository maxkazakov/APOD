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
    
    
    
    func loadPictures(dates: [Date], completion: @escaping (LoadingPictureResult) -> Void) {
        // try from cache
        databaseService.load(dates: dates) { pictures in
            let cacheViewModels = pictures.map { PictureViewModel(from: $0)}
            let cachedCount = cacheViewModels.count
            
            if cachedCount == dates.count {
                print("All loaded from cache")
                completion(.loaded(cacheViewModels))
                return
            }
            
            // cache misses
            let foundDates = Set(cacheViewModels.map { $0.date })
            let missedDates = Set(dates).subtracting(foundDates).sorted{ $0 > $1 }
            
            // try load from network
            self.networkService.loadPictures(from: missedDates) { error, pictures in
                if let error = error {
                    completion(.error(error))
                    return
                }
                guard let pictures = pictures else {
                    return
                }
                
                self.databaseService.save(pictures: pictures)
                let viewModels = pictures.map { PictureViewModel(from: $0)} + cacheViewModels
                completion(.loaded(viewModels.sorted{ $0.date > $1.date }))
            }
        }
    }
    
    
    // MARK: -Private
    
    private let networkService = NetworkApiService()
    private let databaseService = DataBaseService()
}
