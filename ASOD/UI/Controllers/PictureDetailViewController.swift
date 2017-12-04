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
    private let descriptionLabel = UILabel()
    private let authorLabel = UILabel()
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    private var imageHeight: NSLayoutConstraint!
    
    
    
    private func setupConstraints() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        let topScroll = NSLayoutConstraint(item: scrollView, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1, constant: 0)
        let leadingScroll = NSLayoutConstraint(item: scrollView, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: 0)
        let trailingScroll = NSLayoutConstraint(item: scrollView, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1, constant: 0)
        let bottomScroll = NSLayoutConstraint(item: scrollView, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: 0)
        view.addConstraints([topScroll, leadingScroll, trailingScroll, bottomScroll])
        
        contentView.translatesAutoresizingMaskIntoConstraints = false
        let topContent = NSLayoutConstraint(item: contentView, attribute: .top, relatedBy: .equal, toItem: scrollView, attribute: .top, multiplier: 1, constant: 0)
        let leadingContent = NSLayoutConstraint(item: contentView, attribute: .leading, relatedBy: .equal, toItem: scrollView, attribute: .leading, multiplier: 1, constant: 0)
        let trailingContent = NSLayoutConstraint(item: contentView, attribute: .trailing, relatedBy: .equal, toItem: scrollView, attribute: .trailing, multiplier: 1, constant: 0)
        let bottomContent = NSLayoutConstraint(item: contentView, attribute: .bottom, relatedBy: .equal, toItem: scrollView, attribute: .bottom, multiplier: 1, constant: 0)
        let widthContent = NSLayoutConstraint(item: contentView, attribute: .width, relatedBy: .equal, toItem: scrollView, attribute: .width, multiplier: 1, constant: 0)
        scrollView.addConstraints([topContent, leadingContent, trailingContent, bottomContent, widthContent])
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        let topImage = NSLayoutConstraint(item: imageView, attribute: .top, relatedBy: .equal, toItem: contentView, attribute: .top, multiplier: 1, constant: 0)
        let leadingImage = NSLayoutConstraint(item: imageView, attribute: .leading, relatedBy: .equal, toItem: contentView, attribute: .leading, multiplier: 1, constant: 0)
        let trailingImage = NSLayoutConstraint(item: imageView, attribute: .trailing, relatedBy: .equal, toItem: contentView, attribute: .trailing, multiplier: 1, constant: 0)
        imageHeight = NSLayoutConstraint(item: imageView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 100)
        contentView.addConstraints([topImage, leadingImage, trailingImage])
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        let topTitle = NSLayoutConstraint(item: titleLabel, attribute: .top, relatedBy: .equal, toItem: imageView, attribute: .bottom, multiplier: 1, constant: 8)
        let leadingTitle = NSLayoutConstraint(item: titleLabel, attribute: .leading, relatedBy: .equal, toItem: contentView, attribute: .leading, multiplier: 1, constant: 8)
        let trailingTitle = NSLayoutConstraint(item: titleLabel, attribute: .trailing, relatedBy: .equal, toItem: contentView, attribute: .trailing, multiplier: 1, constant: 8)
        contentView.addConstraints([topTitle, leadingTitle, trailingTitle])
        
        authorLabel.translatesAutoresizingMaskIntoConstraints = false
        authorLabel.numberOfLines = 1
        authorLabel.font = UIFont.systemFont(ofSize: 14)
        authorLabel.textColor = UIColor.darkGray
        let topAuthor = NSLayoutConstraint(item: authorLabel, attribute: .top, relatedBy: .equal, toItem: titleLabel, attribute: .bottom, multiplier: 1, constant: 3)
        let leadingAuthor = NSLayoutConstraint(item: authorLabel, attribute: .leading, relatedBy: .equal, toItem: contentView, attribute: .leading, multiplier: 1, constant: 8)
        let trailingAuthor = NSLayoutConstraint(item: authorLabel, attribute: .trailing, relatedBy: .equal, toItem: contentView, attribute: .trailing, multiplier: 1, constant: -8)
        contentView.addConstraints([topAuthor, leadingAuthor, trailingAuthor])
        
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.font = UIFont.systemFont(ofSize: 16)
        descriptionLabel.textColor = UIColor.darkGray
        descriptionLabel.numberOfLines = 0
        let topDescription = NSLayoutConstraint(item: descriptionLabel, attribute: .top, relatedBy: .equal, toItem: authorLabel, attribute: .bottom, multiplier: 1, constant: 3)
        let leadingDescription = NSLayoutConstraint(item: descriptionLabel, attribute: .leading, relatedBy: .equal, toItem: contentView, attribute: .leading, multiplier: 1, constant: 8)
        let trailingDescription = NSLayoutConstraint(item: descriptionLabel, attribute: .trailing, relatedBy: .equal, toItem: contentView, attribute: .trailing, multiplier: 1, constant: -8)
        let bottomDescription = NSLayoutConstraint(item: descriptionLabel, attribute: .bottom, relatedBy: .equal, toItem: contentView, attribute: .bottom, multiplier: 1, constant: 0)
        contentView.addConstraints([topDescription, leadingDescription, trailingDescription, bottomDescription])
        
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        let topButton = NSLayoutConstraint(item: closeButton, attribute: .top, relatedBy: .equal, toItem: contentView, attribute: .top, multiplier: 1, constant: 8)
        let leadingButton = NSLayoutConstraint(item: closeButton, attribute: .leading, relatedBy: .equal, toItem: contentView, attribute: .leading, multiplier: 1, constant: 8)
        let widthButton = NSLayoutConstraint(item: closeButton, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 25)
        let heightButton = NSLayoutConstraint(item: closeButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 25)
        contentView.addConstraints([topButton, leadingButton, widthButton, heightButton])
    }
    
    
    override var prefersStatusBarHidden: Bool {
        return statusBarShouldBeHidden
    }
    
    
    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
        return .none
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        
        contentView.backgroundColor = UIColor.white
        contentView.addSubview(imageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(closeButton)
        contentView.addSubview(authorLabel)
        contentView.addSubview(descriptionLabel)
        
        setupConstraints()        
    }
    
    
    
    
    func setup(picture: PictureViewModel) {
        titleLabel.text = picture.title
        if !picture.copyright.isEmpty {
            authorLabel.text = "Author: \(picture.copyright)"
        }
        descriptionLabel.text = picture.explanation
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
