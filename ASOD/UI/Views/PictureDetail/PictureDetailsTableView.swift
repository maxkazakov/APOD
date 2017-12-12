//
//  PictureDetailsTableView.swift
//  ASOD
//
//  Created by Максим Казаков on 10/12/2017.
//  Copyright © 2017 Максим Казаков. All rights reserved.
//

import UIKit

class PictureDetailTableView: UITableView {
    override init(frame: CGRect, style: UITableViewStyle) {
        super.init(frame: frame, style: style)
        
        if #available(iOS 11.0, *) {
            contentInsetAdjustmentBehavior = .never
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    
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
