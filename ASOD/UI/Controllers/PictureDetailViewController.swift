//
//  PictureDetailViewController.swift
//  ASOD
//
//  Created by Максим Казаков on 02/12/2017.
//  Copyright © 2017 Максим Казаков. All rights reserved.
//

import UIKit
import Kingfisher



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

        
        tableView.insertSubview(backButton, aboveSubview: imageView)
        configureBackButton()
        
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
            guard let header = imageView, let image = image else {
                return
            }
            DispatchQueue.main.async {
                UIView.animate(withDuration: 0.5) {
                    header.setImage(image)
                    self.tableView.tableHeaderView = header
                }
            }
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
