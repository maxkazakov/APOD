//
//  PictureViewModel.swift
//  ASOD
//
//  Created by Максим Казаков on 10/11/2017.
//  Copyright © 2017 Максим Казаков. All rights reserved.
//

import Foundation

enum MediaType: String {
    case unknown = ""
    case image = "image"
    case video = "video"
}


struct PictureViewModel: Hashable, CustomStringConvertible {
    var hashValue: Int {
        return date.hashValue
    }
    
    
    static func ==(lhs: PictureViewModel, rhs: PictureViewModel) -> Bool {
        return lhs.date == rhs.date
            && lhs.url == rhs.url
            && lhs.explanation == rhs.explanation
            && lhs.mediaType == rhs.mediaType
            && lhs.title == rhs.title
            && lhs.hdurl == rhs.hdurl
            && lhs.copyright == rhs.copyright
    }
    
    
    
    let date: Date
    let url: URL?
    let explanation: String
    let mediaType: MediaType
    let title: String
    let hdurl: URL?
    let copyright: String
    
    
    init(from model: PictureModel) {
        self.date = model.date
        self.url = URL(string: model.url)
        self.explanation = model.explanation
        self.mediaType = MediaType(rawValue: model.media_type) ?? MediaType.unknown
        self.title = model.title
        self.hdurl = URL(string: model.url)
        self.copyright = model.copyright
    }
    
    public var description: String {
        return "\(date)"
    }
}
