//
//  PictureModel.swift
//  ASOD
//
//  Created by Максим Казаков on 10/11/2017.
//  Copyright © 2017 Максим Казаков. All rights reserved.
//

import RealmSwift
import Foundation

class PictureModel: Object {
    @objc dynamic var date = Date()
    @objc dynamic var url = ""
    @objc dynamic var explanation = ""
    @objc dynamic var media_type = ""
    @objc dynamic var title = ""
    @objc dynamic var hdurl = ""
    @objc dynamic var copyright = ""
}


