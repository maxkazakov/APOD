//
//  DatabaseService.swift
//  ASOD
//
//  Created by Максим Казаков on 13/11/2017.
//  Copyright © 2017 Максим Казаков. All rights reserved.
//

import Foundation
import RealmSwift



class DatabaseService {
    
    static func load(dates: [Date]) throws ->  [PictureModel]  {
        let realm = try Realm()
        let pictures = Array(realm.objects(PictureModel.self).filter("date IN %@", dates).sorted(byKeyPath: "date", ascending: false))
        return pictures
    }
    
    
    
    static func save(pictures: [PictureModel]) throws {
        let realm = try! Realm()
        try realm.write {
            pictures.forEach {
                realm.add($0)
            }
        }
    }
}
