//
//  ViewController.swift
//  ASOD
//
//  Created by Максим Казаков on 09/11/2017.
//  Copyright © 2017 Максим Казаков. All rights reserved.
//

import UIKit
import ReSwift



class PictureListViewController: UITableViewController {
    
    struct Props {
        struct PictureTableItem {
            let viewModel: PictureViewModel
            let onSelect: (() -> Void)?
        }
        let loadingState: LoadingState
        let items: [PictureTableItem]
        
        let loadData: ((_ portionSize: Int) -> Void)?
        let refreshData: (() -> Void)?
        
        static let zero = Props(loadingState: .none, items: [], loadData: nil, refreshData: nil)
    }
    
    var props = Props.zero {
        didSet {
            switch (props.loadingState) {
            case .loadingMore:
                tableView.tableFooterView?.isHidden = false
                tableViewFooter.setIsLoading(true)
            case .refreshing:
                cellHeights.removeAll()
            case .none:
                tableView.tableFooterView?.isHidden = true
                tableViewFooter.setIsLoading(false)
                refreshControl?.endRefreshing()
            }
            tableView.reloadData()
        }
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
        
        store.subscribe(self) { subscription in
            subscription.select { state in
                return state.picturesState
            }
        }
        // init loading
        props.loadData?(portionSize)
    }
    
    
    
    deinit {
        store.unsubscribe(self)
    }
    
    
    
    
    @objc func refresh(sender: Any) {
        if props.loadingState == .none {
            props.refreshData?()
        }
        else {
            refreshControl?.endRefreshing()
        }
    }
    
    
    
    override var prefersStatusBarHidden: Bool {
        return false
    }

    
    override func viewDidAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = false
    }

    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return props.items.count
    }
    
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PictureViewCell.identifier) as! PictureViewCell
        let viewModel = props.items[indexPath.row].viewModel
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
            props.loadData?(portionSize)
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
        item.onSelect?()
    }
    
    
    

    
    // MARK: -Private    
    private let tableViewFooter = PictureTableFooterView(frame: CGRect(x: 0, y: 0, width: 0, height: 50))
    private var cellHeights: [IndexPath : CGFloat] = [:]
    private let portionSize = 10
    
    
    
    class InteractivePopRecognizer: NSObject, UIGestureRecognizerDelegate {
        
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
    
    private var popRecognizer: InteractivePopRecognizer?
    
    
    private func setInteractiveRecognizer() {
        guard let controller = navigationController else { return }
        popRecognizer = InteractivePopRecognizer(controller: controller)
        controller.interactivePopGestureRecognizer?.delegate = popRecognizer
    }
}






extension PictureListViewController: StoreSubscriber {
    
    func newState(state: PicturesState) {
        let loadData: (Int) -> Void = { portionSize in
            store.dispatch(LoadMorePicturesAction(portionSize: portionSize))
        }
        let refreshData: () -> Void = {
            if state.loading != .refreshing {
                store.dispatch(RefreshPicturesAction())
            }
        }
        
        let items = state.pictures.map { viewModel in
            Props.PictureTableItem(viewModel: viewModel, onSelect: {
                switch viewModel.mediaType {
                case .image:
                    let detailVc = PictureDetailViewController()
                    self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
                    self.navigationController?.pushViewController(detailVc, animated: true)
                    detailVc.setup(picture: viewModel)
                default:
                    break
                }
            })
        }
        props = Props(loadingState: state.loading,
                      items: items,
                      loadData: loadData,
                      refreshData: refreshData
        )
    }
}







