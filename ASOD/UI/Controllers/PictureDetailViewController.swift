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
    
    
    private let closeButton: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "backIcon"), for: .normal)
        button.addTarget(self, action: #selector(PictureDetailViewController.closeAction), for: .touchUpInside)
        return button
    }()
    
    
    @objc private func closeAction() {
        navigationController?.popViewController(animated: true)
    }
    
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
        
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        let topButton = NSLayoutConstraint(item: closeButton, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1, constant: 8)
        let leadingButton = NSLayoutConstraint(item: closeButton, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: 8)
        let widthButton = NSLayoutConstraint(item: closeButton, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 25)
        let heightButton = NSLayoutConstraint(item: closeButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 25)
        view.addConstraints([topButton, leadingButton, widthButton, heightButton])
    }
    
    
    override var prefersStatusBarHidden: Bool {
        return statusBarShouldBeHidden
    }
    
    
    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
        return .none
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.lightGray
        view.addSubview(imageView)
        view.addSubview(titleLabel)
        view.addSubview(closeButton)
        
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
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: true)
        statusBarShouldBeHidden = true
        self.setNeedsStatusBarAppearanceUpdate()
    }

    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    private var statusBarShouldBeHidden: Bool = false
}
