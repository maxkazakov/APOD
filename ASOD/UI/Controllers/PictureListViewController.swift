//
//  ViewController.swift
//  ASOD
//
//  Created by Максим Казаков on 09/11/2017.
//  Copyright © 2017 Максим Казаков. All rights reserved.
//

import UIKit
import ReSwift


class PictureListViewController: UITableViewController, StoreSubscriber {
       
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = tableViewFooter
        tableView.tableFooterView?.isHidden = true
//        navigationItem.rightBarButtonItem = refreshButton
        loadData(portionSize: portiosnSize)
        
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(refresh), for: .valueChanged)
        
        tableView.rowHeight = UITableViewAutomaticDimension
    }
    
    
    @objc func refresh(sender: Any) {
        store.dispatch(RefreshPicturesAction())
    }
    
    
    func newState(state: PicturesState) {
        dataSource = state.pictures
        tableView.reloadData()
        setIsLoading(state.loading)
    }

    

    override func viewWillAppear(_ animated: Bool) {
        store.subscribe(self) { subscription in
            subscription.select { state in
                return state.picturesState
            }
        }
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
    
    
    // MARK: -Private
    private var dataSource = [PictureViewModel]()
    private let tableViewFooter = PictureTableFooterView(frame: CGRect(x: 0, y: 0, width: 0, height: 50))
    private var isLoading: LoadingState = .none
    private var portiosnSize = 5
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
            refreshControl?.endRefreshing()
            
        case (.loadingMore, .refreshing), (.refreshing, .loadingMore):
            print("WTF?")
        
        default:
            break
        }
        
        isLoading = value        
    }
    
    
    
    func loadData(portionSize: Int) {
        store.dispatch(LoadMorePicturesAction(portionSize: portionSize))
    }
}

