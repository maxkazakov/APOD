//
//  UIImage+Extention.swift
//  ASOD
//
//  Created by Максим Казаков on 02/12/2017.
//  Copyright © 2017 Максим Казаков. All rights reserved.
//

import UIKit


extension UIImage {
    func ratioImage(toWidth width: CGFloat) -> UIImage {
        let oldWidth = self.size.width
        let scaleFactor = width / oldWidth
        
        let newHeight = Int(self.size.height * scaleFactor)
        let newWidth = Int(oldWidth * scaleFactor)
        
        UIGraphicsBeginImageContextWithOptions(CGSize(width: newWidth, height: newHeight), true, UIScreen.main.scale)
        self.draw(in: CGRect(x: 0, y: 0, width: newWidth, height: newHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        print(newImage!.scale)
        return newImage!
    }
}

