//
//  NetworkApiService.swift
//  ASOD
//
//  Created by Максим Казаков on 13/11/2017.
//  Copyright © 2017 Максим Казаков. All rights reserved.
//

import Foundation

enum NetworkError: Error {
    case error(message: String)
}


class NetworkApiService {
    
    func loadPictures(from date: Date, portionSize: Int, completion: @escaping (Error?, [PictureModel]?) -> Void) {
        let dateStr = PictureViewModel.dateFormatter.string(from: date)
        
        let queryItems = [URLQueryItem(name: "date", value: dateStr), URLQueryItem(name: "portionSize", value: String(portionSize))]
        var urlComponents = URLComponents(string: api)!
        urlComponents.queryItems = queryItems
        let url = urlComponents.url!
        let urlRequest = URLRequest(url: url)        
        let session = URLSession.shared
        let task = session.dataTask(with: urlRequest) { data, reponse, error in
            if let error = error {
                completion(error, nil)
                return
            }
            
            
            guard let responseData = data else {
                completion(NetworkError.error(message: "Error: did not receive data"), nil)
                return
            }
            
            
            if let httpResponse = reponse as? HTTPURLResponse, httpResponse.statusCode != 200 {
                let message = String(data: responseData, encoding: .utf8) ?? ""
                completion(NetworkError.error(message: "Code: \(httpResponse.statusCode). Message: \(message)"), nil)
                return
            }
            
            
            var pictures = [PictureModel]()
            do {
                guard let jsonObj = try JSONSerialization.jsonObject(with: responseData, options: []) as? [Any] else {
                    completion(NetworkError.error(message: "Error trying to convert data to JSON"), nil)
                    return
                }
                for value in jsonObj {
                    guard var dict = value as? [String: Any] else {
                        completion(NetworkError.error(message: "Error trying to convert data to JSON"), nil)
                        return
                    }
                    guard let date = PictureViewModel.dateFormatter.date(from: dict["date"] as! String) else {
                        completion(NetworkError.error(message: "Error trying to convert date from string to Date"), nil)
                        return
                    }
                    dict["date"] = date
                    let picture = PictureModel(value: dict)
                    pictures.append(picture)
                }
                completion(nil, pictures)
            } catch  {
                completion(error, nil)
                print("error trying to convert data to JSON")
                return
            }
        }
        task.resume()
    }
    
    
    private let api = "https://asod-server.herokuapp.com/pictures"
}
