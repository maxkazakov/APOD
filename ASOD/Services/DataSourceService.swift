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
    
    
    
    func loadMorePictures(from date: Date?, portionSize: Int, completion: @escaping (LoadingPictureResult) -> Void) {
        let date = date?.getDateFor(days: -1) ?? Date().withoutTime().getDateFor(days: -1)!
        
        var requiredDates = [Date]()
        for i in 0...(portionSize - 1) {
            requiredDates.append(date.getDateFor(days: -i)!)
        }
        
        // try from cache
        databaseService.load(dates: requiredDates) { pictures in
            let viewModels = pictures.map { PictureViewModel(from: $0)}
            let cachedCount = viewModels.count
            
            if cachedCount == portionSize {
                print("All loaded from cache")
                completion(.loaded(viewModels))
                return
            }
            
            // cache misses
            let foundDates = Set(viewModels.map { $0.date })
            let missedDates = Set(requiredDates).subtracting(foundDates).sorted{ $0 > $1 }
            
            // try load from network
            self.networkService.loadPictures(from: missedDates) { error, pictures in
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
