//
//  ResizeImageProcessor.swift
//  ASOD
//
//  Created by Максим Казаков on 11/12/2017.
//  Copyright © 2017 Максим Казаков. All rights reserved.
//

import UIKit
import Kingfisher

struct ResizeImageProcessor: ImageProcessor {
    
    var identifier: String {
        return "com.apod.resizer.width.\(width)"
    }
    
    let width: CGFloat
    
    func process(item: ImageProcessItem, options: KingfisherOptionsInfo) -> Image? {
        switch item {
        case .image(let image):
            return image.ratioImage(toWidth: width)
            
        case .data(let data):
            return UIImage(data: data).map{ $0.ratioImage(toWidth: width) }            
        }
    }
}
