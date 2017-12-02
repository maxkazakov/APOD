//
//  PictureDetailViewController.swift
//  ASOD
//
//  Created by Максим Казаков on 02/12/2017.
//  Copyright © 2017 Максим Казаков. All rights reserved.
//

import UIKit
import Kingfisher

class PictureDetailViewController: UIViewController {
    
    private let imageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleToFill
        return view
    }()
    
    private let titleLabel = UILabel()
    
    var imageHeight: NSLayoutConstraint!
    
    private func setupConstraints() {
        print(view.frame)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        let topImage = NSLayoutConstraint(item: imageView, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1, constant: 0)
        let leadingImage = NSLayoutConstraint(item: imageView, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: 0)
        let trailingImage = NSLayoutConstraint(item: imageView, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1, constant: 0)
        imageHeight = NSLayoutConstraint(item: imageView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 100)
        view.addConstraints([topImage, leadingImage, trailingImage])
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        let topTitle = NSLayoutConstraint(item: titleLabel, attribute: .top, relatedBy: .equal, toItem: imageView, attribute: .bottom, multiplier: 1, constant: 0)
        let leadingTitle = NSLayoutConstraint(item: titleLabel, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: 0)
        let trailingTitle = NSLayoutConstraint(item: titleLabel, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1, constant: 0)
        view.addConstraints([topTitle, leadingTitle, trailingTitle])
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.lightGray
        view.addSubview(imageView)
        view.addSubview(titleLabel)
        
        navigationController?.navigationBar.isTranslucent = false
        
        setupConstraints()
    }
    
    
    
    
    func setup(picture: PictureViewModel) {
        titleLabel.text = picture.title
        guard let imageUrl = picture.url else {
            return
        }
        
        let resource = ImageResource(downloadURL: imageUrl)
        let imageWidth = view.frame.width
        
        KingfisherManager.shared.retrieveImage(with: resource, options: nil, progressBlock: nil) { [weak imageView] image, _, _, _ in
            guard let imageView = imageView, let image = image else {
                return
            }
            let newImage = image.ratioImage(toWidth: imageWidth)
            print(newImage.size)
            imageView.image = newImage
        }
    }
    
}
