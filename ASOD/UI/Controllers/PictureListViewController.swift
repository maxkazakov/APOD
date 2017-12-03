//
//  ViewController.swift
//  ASOD
//
//  Created by Максим Казаков on 09/11/2017.
//  Copyright © 2017 Максим Казаков. All rights reserved.
//

import UIKit
import ReSwift

fileprivate class InteractivePopRecognizer: NSObject, UIGestureRecognizerDelegate {
    
    var navigationController: UINavigationController
    
    init(controller: UINavigationController) {
        self.navigationController = controller
    }
    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return navigationController.viewControllers.count > 1
    }
    
    // This is necessary because without it, subviews of your top controller can
    // cancel out your gesture recognizer on the edge.
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}


class PictureListViewController: UITableViewController, StoreSubscriber {
    private var popRecognizer: InteractivePopRecognizer?
    
    
    private func setInteractiveRecognizer() {
        guard let controller = navigationController else { return }
        popRecognizer = InteractivePopRecognizer(controller: controller)
        controller.interactivePopGestureRecognizer?.delegate = popRecognizer
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = tableViewFooter
        tableView.tableFooterView?.isHidden = true
        if #available(iOS 11.0, *) {
            tableView.contentInsetAdjustmentBehavior = .never
        }
        title = "Astronomy pictures of the day"
//        navigationItem.rightBarButtonItem = refreshButton
        loadData(portionSize: portiosnSize)
        tableView.separatorStyle = .none
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(refresh), for: .valueChanged)
        
        tableView.rowHeight = UITableViewAutomaticDimension
        setInteractiveRecognizer()
    }
    
    
    
    @objc func refresh(sender: Any) {
        if isLoading == .none {
            store.dispatch(RefreshPicturesAction())
        }
        else {
            refreshControl?.endRefreshing()
        }
    }
    
    
    override var prefersStatusBarHidden: Bool {
        return false
    }
    
    
    func newState(state: PicturesState) {
        dataSource = state.pictures
        setIsLoading(state.loading)
        tableView.reloadData()
    }

    

    override func viewWillAppear(_ animated: Bool) {
        store.subscribe(self) { subscription in
            subscription.select { state in
                return state.picturesState
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = false
    }

    
    
    override func viewWillDisappear(_ animated: Bool) {
        store.unsubscribe(self)        
    }
    
    
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PictureViewCell.identifier) as! PictureViewCell
        let viewModel = dataSource[indexPath.row]
        cell.setup(viewModel: viewModel)
        return cell
    }
    
    
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cellHeights[indexPath] = cell.frame.size.height
        if isLoading == .loadingMore {
            return
        }
        let contentOffset = dataSource.count - (indexPath.row + 1)
        if contentOffset == 0 {
            loadData(portionSize: portiosnSize)
        }
    }
    
    
    
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let height = cellHeights[indexPath] else {
            return 100
        }
        return height
    }
    
    
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let picture = dataSource[indexPath.row]
        switch picture.mediaType {
        case .image:
            let detailVc = PictureDetailViewController()
            navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
            navigationController?.pushViewController(detailVc, animated: true)
            detailVc.setup(picture: picture)            
        default:
            break
        }        
    }
    
    
    

    
    // MARK: -Private
    private var dataSource = [PictureViewModel]()
    private let tableViewFooter = PictureTableFooterView(frame: CGRect(x: 0, y: 0, width: 0, height: 50))
    private var isLoading: LoadingState = .none
    private var portiosnSize = 10
    private var cellHeights: [IndexPath : CGFloat] = [:]
    
    
    
//    lazy var refreshButton: UIBarButtonItem = {
//        UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(PictureListViewController.reload))
//    }()
//
//
//
//    @objc private func reload() {
//        loadData(from: nil, portionSize: portiosnSize)
//    }
    
    
    
    private func setIsLoading(_ value: LoadingState) {
        switch (isLoading, value) {
        case (.none, .loadingMore):
            tableView.tableFooterView?.isHidden = false
            tableViewFooter.setIsLoading(true)
            
        case (.loadingMore, .none):
            tableView.tableFooterView?.isHidden = true
            tableViewFooter.setIsLoading(false)
            
        case (.refreshing, .none):
            cellHeights.removeAll()
            refreshControl?.endRefreshing()
        
        default:
            break
        }
        
        isLoading = value        
    }
    
    
    
    func loadData(portionSize: Int) {
        store.dispatch(LoadMorePicturesAction(portionSize: portionSize))
    }
}

