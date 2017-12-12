//
//  PictureDetailsHeaderView.swift
//  ASOD
//
//  Created by Максим Казаков on 12/12/2017.
//  Copyright © 2017 Максим Казаков. All rights reserved.
//

import UIKit

class PictureDetailsHeaderView: UIView {
    static let identifier = String(describing: PictureDetailsHeaderView.self)
    
    private let pictureView = UIImageView()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        pictureView.contentMode = .scaleAspectFill
        addSubview(pictureView)
        setupConstraints()
    }
    
    var imageHeight: NSLayoutConstraint!
    var bottom: NSLayoutConstraint!
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setImage(_ image: UIImage) {
        pictureView.image = image
        frame.size = image.size
        imageHeight.constant = image.size.height
    }
    
    
    private func setupConstraints() {
        pictureView.translatesAutoresizingMaskIntoConstraints = false
        bottom = NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: .equal, toItem: pictureView, attribute: .bottom, multiplier: 1, constant: 0)
        let leading = NSLayoutConstraint(item: pictureView, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: 0)
        let trailing = NSLayoutConstraint(item: pictureView, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: 0)
        self.addConstraints([bottom, leading, trailing])
        
        imageHeight = NSLayoutConstraint(item: pictureView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 200)
        pictureView.addConstraint(imageHeight)
    }
}
