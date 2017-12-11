//
//  PictureDetailViewController.swift
//  ASOD
//
//  Created by Максим Казаков on 02/12/2017.
//  Copyright © 2017 Максим Казаков. All rights reserved.
//

import UIKit
import Kingfisher

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
        setNeedsLayout()
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



class PictureDescriptionViewCell: UITableViewCell {
    
    static let identifier = String(describing: PictureDescriptionViewCell.self)
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(titleLabel)
        contentView.addSubview(authorLabel)
        contentView.addSubview(descriptionLabel)
        setupConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    private let titleLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let authorLabel = UILabel()
    
    
    
    private func setupConstraints() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        let topTitle = NSLayoutConstraint(item: titleLabel, attribute: .top, relatedBy: .equal, toItem: contentView, attribute: .top, multiplier: 1, constant: 8)
        let leadingTitle = NSLayoutConstraint(item: titleLabel, attribute: .leading, relatedBy: .equal, toItem: contentView, attribute: .leading, multiplier: 1, constant: 8)
        let trailingTitle = NSLayoutConstraint(item: titleLabel, attribute: .trailing, relatedBy: .equal, toItem: contentView, attribute: .trailing, multiplier: 1, constant: 8)
        contentView.addConstraints([topTitle, leadingTitle, trailingTitle])
        
        authorLabel.translatesAutoresizingMaskIntoConstraints = false
        authorLabel.numberOfLines = 0
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
        let topDescription = NSLayoutConstraint(item: descriptionLabel, attribute: .top, relatedBy: .equal, toItem: authorLabel, attribute: .bottom, multiplier: 1, constant: 12)
        let leadingDescription = NSLayoutConstraint(item: descriptionLabel, attribute: .leading, relatedBy: .equal, toItem: contentView, attribute: .leading, multiplier: 1, constant: 8)
        let trailingDescription = NSLayoutConstraint(item: descriptionLabel, attribute: .trailing, relatedBy: .equal, toItem: contentView, attribute: .trailing, multiplier: 1, constant: -8)
        let bottomDescription = NSLayoutConstraint(item: descriptionLabel, attribute: .bottom, relatedBy: .equal, toItem: contentView, attribute: .bottom, multiplier: 1, constant: 0)
        contentView.addConstraints([topDescription, leadingDescription, trailingDescription, bottomDescription])
    }
    
    
    func setup(picture: PictureViewModel) {
        titleLabel.text = picture.title
        if !picture.copyright.isEmpty {
            authorLabel.text = "Author: \(picture.copyright)"
        }
        descriptionLabel.text = picture.explanation
    }
    
}




class PictureDetailViewController: UITableViewController {

    
    override var prefersStatusBarHidden: Bool {
        return statusBarShouldBeHidden
    }
    
    
    
    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
        return .none
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView = PictureDetailTableView(frame: self.view.bounds, style: .grouped)
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.register(PictureDescriptionViewCell.self, forCellReuseIdentifier: PictureDescriptionViewCell.identifier)
        tableView.tableHeaderView = imageView
        
//        tableView.insertSubview(backButton, aboveSubview: imageView)
//        configureBackButton()
        
        tableView.separatorStyle = .none
    }
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PictureDescriptionViewCell.identifier) as! PictureDescriptionViewCell
        cell.setup(picture: pictureViewModel)
        return cell
    }
    
    
    
    func setup(picture: PictureViewModel) {
        self.pictureViewModel = picture
        
        guard let url = picture.url else {
            return
        }
        loadImage(url: url)
    }
    
    
    
    
    func loadImage(url: URL) {
        let imageWidth = tableView.frame.width
        let resource = ImageResource(downloadURL: url)
        let processor = ResizeImageProcessor(width: imageWidth)
        KingfisherManager.shared.retrieveImage(with: resource, options: [.processor(processor)], progressBlock: nil) { [weak imageView] image, _, _, _ in
            guard let view = imageView, let image = image else {
                return
            }
            view.setImage(image)
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
    
    
    
    // MARK: -Private
    
    private let imageView = PictureDetailsHeaderView(frame: CGRect.zero)
    private var pictureViewModel: PictureViewModel!
    private var imageHeight: NSLayoutConstraint!
    private var statusBarShouldBeHidden: Bool = false
    
    
    
    private let backButton: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "backIcon"), for: .normal)
        button.addTarget(self, action: #selector(PictureDetailViewController.closeAction), for: .touchUpInside)
        return button
    }()
    
    
    
    
    @objc private func closeAction() {
        navigationController?.popViewController(animated: true)
    }
    

    
    
    private func configureBackButton() {
        backButton.translatesAutoresizingMaskIntoConstraints = false
        let topButton = NSLayoutConstraint(item: backButton, attribute: .top, relatedBy: .equal, toItem: tableView, attribute: .top, multiplier: 1, constant: 8)
        let leadingButton = NSLayoutConstraint(item: backButton, attribute: .leading, relatedBy: .equal, toItem: tableView, attribute: .leading, multiplier: 1, constant: 8)
        let widthButton = NSLayoutConstraint(item: backButton, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 25)
        let heightButton = NSLayoutConstraint(item: backButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 25)
        tableView.addConstraints([topButton, leadingButton, widthButton, heightButton])
    }
}
