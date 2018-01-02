//
//  PictureDetailViewController.swift
//  ASOD
//
//  Created by Максим Казаков on 02/12/2017.
//  Copyright © 2017 Максим Казаков. All rights reserved.
//

import UIKit
import Kingfisher
import ReSwift



class PictureDetailViewController: UITableViewController {
    
    struct Props {
        let viewModel: PictureViewModel?
        
        static let zero = Props(viewModel: nil)
    }
    
    
    var props = Props.zero {
         didSet {
            guard let viewModel = props.viewModel else {
                return
            }
            loadImage(url: viewModel.url, width: tableView.frame.width)
            tableView.reloadData()
        }
    }
    
    
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
        headerView.set(height: 200)
        tableView.tableHeaderView = headerView

        
        tableView.insertSubview(backButton, aboveSubview: headerView)
        configureBackButton()
        
        tableView.separatorStyle = .none
        
        store.subscribe(self) { subscription in
            subscription.select { state in
                return state.selectedPicture
            }
        }
    }
    
    
    
    deinit {
        store.unsubscribe(self)
    }
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return props.viewModel == nil ? 0 : 1
    }
    
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PictureDescriptionViewCell.identifier) as! PictureDescriptionViewCell
        cell.setup(picture: props.viewModel!)
        return cell
    }

    
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        loadImage(url: props.viewModel?.url, width: size.width)
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
    
    private let headerView = PictureDetailsHeaderView(frame: CGRect.zero)
    private var imageHeight: NSLayoutConstraint!
    private var statusBarShouldBeHidden: Bool = false
    
    
    
    private func loadImage(url: URL?, width: CGFloat) {
        guard let url = url else {
            return
        }
        let resource = ImageResource(downloadURL: url)
        let processor = ResizeImageProcessor(width: width)
        
        let imageView = headerView.pictureView
        imageView.kf.indicatorType = .activity
        imageView.kf.setImage(with: resource, options: [.processor(processor)], progressBlock: nil) { image, _, _, _ in
            guard let image = image else {
                return
            }
            let imageHeight = image.scale == 1.0 ? image.size.height / UIScreen.main.scale : image.size.height
            DispatchQueue.main.async {
                UIView.animate(withDuration: 0.3) {
                    self.headerView.set(height: imageHeight)
                    self.tableView.tableHeaderView = self.headerView
                }
            }
        }
    }
    
    
    
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



extension PictureDetailViewController: StoreSubscriber {
    
    func newState(state: SelectedPictureState) {
        props = Props(viewModel: state.picture)
    }
}

