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
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}


class PictureListViewController: UITableViewController, StoreSubscriber {
    
    struct Props {
        let loadingState: LoadingState
        let items: [PictureViewModel]
        let select: ((PictureViewModel) -> ())?
        
        static let zero = Props(loadingState: .none, items: [], select: nil)
    }
    
    
    var props = Props.zero {
        didSet {
            switch (props.loadingState) {
            case .loadingMore:
                tableView.tableFooterView?.isHidden = false
                tableViewFooter.setIsLoading(true)
            case .refreshing:
                cellHeights.removeAll()
                refreshControl?.endRefreshing()
            case .none:
                tableView.tableFooterView?.isHidden = true
                tableViewFooter.setIsLoading(false)
            }
            tableView.reloadData()
        }
    }
    
    
    
    func newState(state: PicturesState) {
        props = Props(loadingState: state.loading, items: state.pictures, select: self.select)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = tableViewFooter
        tableView.tableFooterView?.isHidden = true
        if #available(iOS 11.0, *) {
            tableView.contentInsetAdjustmentBehavior = .never
        }
        title = "Astronomy pictures of the day"
        
        tableView.separatorStyle = .none
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(refresh), for: .valueChanged)
        
        tableView.rowHeight = UITableViewAutomaticDimension
        setInteractiveRecognizer()
        
        // init loading
        loadData(portionSize: portiosnSize)
    }
    
    
    
    @objc func refresh(sender: Any) {
        if props.loadingState == .none {
            refreshData()
        }
        else {
            refreshControl?.endRefreshing()
        }
    }
    
    
    
    override var prefersStatusBarHidden: Bool {
        return false
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
        return props.items.count
    }
    
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PictureViewCell.identifier) as! PictureViewCell
        let viewModel = props.items[indexPath.row]
        cell.setup(viewModel: viewModel)
        return cell
    }
    
    
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cellHeights[indexPath] = cell.frame.size.height
        if props.loadingState == .loadingMore {
            return
        }
        let contentOffset = props.items.count - (indexPath.row + 1)
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
        let item = props.items[indexPath.row]
        props.select?(item)
    }
    
    
    

    
    // MARK: -Private    
    private let tableViewFooter = PictureTableFooterView(frame: CGRect(x: 0, y: 0, width: 0, height: 50))
    private var portiosnSize = 10
    private var cellHeights: [IndexPath : CGFloat] = [:]
    
    
    
    private var popRecognizer: InteractivePopRecognizer?
    
    
    private func setInteractiveRecognizer() {
        guard let controller = navigationController else { return }
        popRecognizer = InteractivePopRecognizer(controller: controller)
        controller.interactivePopGestureRecognizer?.delegate = popRecognizer
    }
    
    
    private func loadData(portionSize: Int) {
        store.dispatch(LoadMorePicturesAction(portionSize: portionSize))
    }
    
    
    
    private func refreshData() {
        store.dispatch(RefreshPicturesAction())
    }
    
    
    
    private func select(picture item: PictureViewModel) {
        switch item.mediaType {
        case .image:
            let detailVc = PictureDetailViewController()
            self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
            self.navigationController?.pushViewController(detailVc, animated: true)
            detailVc.setup(picture: item)
        default:
            break
        }
    }
}

