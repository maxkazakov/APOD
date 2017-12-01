//
//  NetworkApiService.swift
//  ASOD
//
//  Created by Максим Казаков on 13/11/2017.
//  Copyright © 2017 Максим Казаков. All rights reserved.
//

import Foundation
import Alamofire

enum NetworkError: Error {
    case error(message: String)
}

fileprivate let url = "https://asod-server.herokuapp.com/pictures"
fileprivate let testurl = "http://localhost:5000/pictures"


fileprivate func syncRequest(_ url: String, parameters: Alamofire.Parameters) -> DataResponse<Any> {
    var outResponse: DataResponse<Any>!
    let semaphore: DispatchSemaphore! = DispatchSemaphore(value: 0)
    
    Alamofire.request(url, parameters: parameters)
        .validate(statusCode: 200..<300)
        .validate(contentType: ["application/json"])
        .responseJSON { response in
            outResponse = response
            semaphore.signal()
    }
    
    let _ = semaphore.wait(timeout: DispatchTime.distantFuture)
    return outResponse
}



class NetworkApiService {
    static func loadPictures(from dates: [Date]) throws -> [PictureModel] {
        let parameters: Parameters = ["dates" : dates.map{ dateFormatter.string(from: $0) }]
        
        let response = syncRequest(url, parameters: parameters)
        
        switch response.result {
        case .success(let data):
            var pictures = [PictureModel]()
            guard let jsonArr = data as? [Any] else {
                throw NetworkError.error(message: "Error trying to convert data to JSON")
            }
            for value in jsonArr {
                guard var dict = value as? [String: Any] else {
                    throw NetworkError.error(message: "Error trying to convert data to JSON")
                }
                guard let date = dateFormatter.date(from: dict["date"] as! String) else {
                    throw NetworkError.error(message: "Error trying to convert date from string to Date")
                }
                dict["date"] = date
                let picture = PictureModel(value: dict)
                pictures.append(picture)
            }
            return pictures
            
        case .failure(let error):
            throw error
        }
    }
}


