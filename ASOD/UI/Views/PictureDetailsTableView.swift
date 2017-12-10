//
//  PictureDetailsTableView.swift
//  ASOD
//
//  Created by Максим Казаков on 10/12/2017.
//  Copyright © 2017 Максим Казаков. All rights reserved.
//

import UIKit

class PictureDetailTableView: UITableView {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        guard let header = tableHeaderView as? PictureDetailsHeaderView else {
            return
        }
        let offsetY = -contentOffset.y
        
        header.bottom.constant = offsetY >= 0 ? 0 : offsetY / 2
        header.clipsToBounds = offsetY <= 0
        header.imageHeight.constant = max(header.bounds.height, header.bounds.height + offsetY)        
    }
}
