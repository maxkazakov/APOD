//
//  PictureTableFooter.swift
//  ASOD
//
//  Created by Максим Казаков on 12/11/2017.
//  Copyright © 2017 Максим Казаков. All rights reserved.
//

import UIKit


class PictureTableFooterView: UIView {
    let busyIndicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(busyIndicator)        
        setupConstraints()
    }
    
    
    
    func setIsLoading(_ value: Bool) {
        value ? busyIndicator.startAnimating() : busyIndicator.stopAnimating()
    }
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    func setupConstraints() {
        busyIndicator.translatesAutoresizingMaskIntoConstraints = false
        let alignYConstraint = NSLayoutConstraint(item: busyIndicator, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0)
        let alignXConstraint = NSLayoutConstraint(item: busyIndicator, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0)
        self.addConstraints([alignYConstraint, alignXConstraint])
    }
}


