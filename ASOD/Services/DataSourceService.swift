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
    
    static func loadPictures(dates: [Date]) -> LoadingPictureResult {
        do {
            // from cache first
            var pictures = try DatabaseService.load(dates: dates)
            let cacheViewModels = pictures.map { PictureViewModel(from: $0)}
            let cachedCount = cacheViewModels.count
            
            if cachedCount == dates.count {
                print("All loaded from cache")
                return .loaded(cacheViewModels)
            }
            
            // cache misses
            let foundDates = Set(cacheViewModels.map { $0.date })
            let missedDates = Set(dates).subtracting(foundDates).sorted{ $0 > $1 }
            
            // try load from network
            pictures = try NetworkApiService.loadPictures(from: missedDates)
            try DatabaseService.save(pictures: pictures)
            let viewModels = pictures.map { PictureViewModel(from: $0)} + cacheViewModels
            
            return .loaded(viewModels.sorted{ $0.date > $1.date })
        }
        catch {
            return .error(error)
        }
    }
    
    
    
    
    static func loadPicturesAsync(from dates: [Date], queue: DispatchQueue = .main, completion: @escaping (Error?, [PictureViewModel]) -> Void) {
        let serialQueue = DispatchQueue(label: "com.apod.loadPictures", qos: .userInitiated)
        // from cache first
        DatabaseService.loadAsync(dates: dates, queue: serialQueue) { error, cacheViewModels in
            if let error = error {
                queue.async {
                    completion(error, [])
                }
                return
            }
            
            let cachedCount = cacheViewModels.count
            queue.async {
                completion(nil, cacheViewModels)
            }
            
            if cachedCount == dates.count {
                print("All loaded from cache")
                return
            }
            
            // cache misses
            let foundDates = Set(cacheViewModels.map { $0.date })
            let missedDates = Set(dates).subtracting(foundDates).sorted{ $0 > $1 }
            
            // try load from network
            NetworkApiService.loadPicturesAsync(from: missedDates, queue: serialQueue) { error, pictures in
                DatabaseService.saveAsync(pictures: pictures)
                let viewModels = pictures.map { PictureViewModel(from: $0)}
                queue.async {
                    completion(nil, viewModels)
                }
            }
        } 
    }
}








