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


class NetworkApiService {
    private let url = "https://asod-server.herokuapp.com/pictures"
    private let testurl = "http://localhost:5000/pictures"
    
    
    func loadPictures(from dates: [Date], completion: @escaping (Error?, [PictureModel]?) -> Void) {
        let parameters: Parameters = ["dates" : dates.map{ dateFormatter.string(from: $0) }]
        Alamofire.request(url, parameters: parameters)
            .validate(statusCode: 200..<300)
            .validate(contentType: ["application/json"])
            .responseJSON { response in
                switch response.result {
                case .success(let data):
                    var pictures = [PictureModel]()
                    guard let jsonArr = data as? [Any] else {
                        completion(NetworkError.error(message: "Error trying to convert data to JSON"), nil)
                        return
                    }
                    for value in jsonArr {
                        guard var dict = value as? [String: Any] else {
                            completion(NetworkError.error(message: "Error trying to convert data to JSON"), nil)
                            return
                        }
                        guard let date = dateFormatter.date(from: dict["date"] as! String) else {
                            completion(NetworkError.error(message: "Error trying to convert date from string to Date"), nil)
                            return
                        }
                        dict["date"] = date
                        let picture = PictureModel(value: dict)
                        pictures.append(picture)
                    }
                    completion(nil, pictures)

                case .failure(let error):
                    completion(error, nil)
                }
        }
    }
}

