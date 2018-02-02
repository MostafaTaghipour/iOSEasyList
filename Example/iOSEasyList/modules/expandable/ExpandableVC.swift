//
//  EndlessVC.swift
//  ListExample-iOS
//
//  Created by Mostafa Taghipour on 1/4/18.
//  Copyright © 2018 RainyDay. All rights reserved.
//

import UIKit
import RxSwift
import RxGesture

class ExpandableVC: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    var viewModel:ExpandableVM!
    var bag=DisposeBag()
    
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.backgroundColor
        self.title="Expandable"
        
        viewModel=ExpandableVM()
        
        //config tableview
        tableView.register(UINib(nibName: MovieCell.className, bundle: nil), forCellReuseIdentifier: MovieCell.reuseIdentifier)
        tableView.register(UINib(nibName: CollapsibleTableViewHeader.className, bundle: nil), forHeaderFooterViewReuseIdentifier: CollapsibleTableViewHeader.reuseIdentifier)
        tableView.allowsSelection=false
        tableView.removeExtraLines()
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 125
       
        //config adapter
        let adapter=ExpandableAdapter(tableView: tableView)

        //bind tableview
        viewModel
            .items
            .asDriver()
            .drive(onNext: { (items) in
                adapter.setData(newData: items)
            })
            .disposed(by: bag)
                
    }
}



