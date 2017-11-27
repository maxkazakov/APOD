//
//  DatabaseService.swift
//  ASOD
//
//  Created by Максим Казаков on 13/11/2017.
//  Copyright © 2017 Максим Казаков. All rights reserved.
//

import Foundation
import RealmSwift



class DataBaseService {
    
    func load(from date: Date, portionSize: Int, completion: ([PictureModel]) -> Void) {
        let realm = try! Realm()
        let pictures = Array(realm.objects(PictureModel.self).filter("date <= %@", date).sorted(byKeyPath: "date", ascending: false).prefix(portionSize))
        completion(pictures)
    }
    
    
    func save(pictures: [PictureModel]) {
        let realm = try! Realm()
        try? realm.write {
            pictures.forEach {
                realm.add($0)
            }
        }
    }
    
    // MARK: -Private
//    private let realm = try! Realm()
}
