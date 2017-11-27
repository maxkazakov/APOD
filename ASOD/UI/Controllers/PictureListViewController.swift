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
        navigationItem.rightBarButtonItem = refreshButton
        loadData(from: dataSource.last?.date, portionSize: portiosnSize)
        
        tableView.rowHeight = UITableViewAutomaticDimension
    }
    
    
    
    func newState(state: PicturesState) {
        setIsLoading(state.loading)
        dataSource = state.pictures
        tableView.reloadData()
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
        if isLoading {
            return
        }
        let contentOffset = dataSource.count - (indexPath.row + 1)
        if contentOffset == 0 {
            loadData(from: dataSource.last?.date, portionSize: portiosnSize)
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
    private var isLoading = false
    private var portiosnSize = 5
    private var cellHeights: [IndexPath : CGFloat] = [:]
    
    lazy var refreshButton: UIBarButtonItem = {
        UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(PictureListViewController.reload))
    }()
    
    
    
    @objc private func reload() {
        loadData(from: nil, portionSize: portiosnSize)
    }
    
    
    
    private func setIsLoading(_ value: LoadingState) {
        switch value {
        case .loadingMore:
            isLoading = true
        default:
            isLoading = false
        }
        tableView.tableFooterView?.isHidden = !isLoading
        tableViewFooter.setIsLoading(isLoading)
    }
    
    
    
    func loadData(from date: Date?, portionSize: Int) {
        store.dispatch(LoadMorePicturesAction(portionSize: portionSize))
    }
}

