//
//  FilteringViewController.swift
//  ListExample-iOS
//
//  Created by Mostafa Taghipour on 1/17/18.
//  Copyright © 2018 RainyDay. All rights reserved.
//

import UIKit
import RxSwift
import RxGesture
import iOSEasyList

class FilteringVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var viewModel:FilteringVM!
    var bag=DisposeBag()
    var adapter:FilteringAdapter!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.backgroundColor
        self.title="Filtering"
        self.navigationController?.navigationBar.prefersLargeTitles=true
        self.navigationItem.rightBarButtonItem=UIBarButtonItem(title: "Order", style: .plain, target: self, action: #selector(self.ordering))
        let search = UISearchController(searchResultsController: nil)
        search.dimsBackgroundDuringPresentation=false
        search.searchResultsUpdater = self
        self.navigationItem.searchController = search
        
        viewModel=FilteringVM()
        
        //config tableview
        tableView.register(UINib(nibName: MovieCell.className, bundle: nil), forCellReuseIdentifier: MovieCell.reuseIdentifier)
        tableView.allowsSelection=false
        tableView.removeExtraLines()
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 125
        
        adapter=FilteringAdapter(tableView: tableView)
        
        //bind tableview
        viewModel
            .items
            .asDriver()
            .drive(onNext: { (items) in
                self.adapter.setData(newData: items)
            })
            .disposed(by: bag)
    }
    
    @objc func ordering(){
        // 1
        let orderMenu = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        // 2
        let TitleAction = UIAlertAction(title: "Title", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            self.viewModel.sort(by: .Title)
        })
        let YearAction = UIAlertAction(title: "Year", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            self.viewModel.sort(by: .Year)
        })
        let LangAction = UIAlertAction(title: "Language", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            self.viewModel.sort(by: .Language)
        })
        
        //
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        
        // 4
        orderMenu.addAction(TitleAction)
        orderMenu.addAction(YearAction)
        orderMenu.addAction(LangAction)
        orderMenu.addAction(cancelAction)
        
        // 5
        self.present(orderMenu, animated: true, completion: nil)
    }
}

extension FilteringVC:UISearchResultsUpdating{
    func updateSearchResults(for searchController: UISearchController) {
        adapter.setFilterConstraint(constraint: searchController.searchBar.text)
    }
}
