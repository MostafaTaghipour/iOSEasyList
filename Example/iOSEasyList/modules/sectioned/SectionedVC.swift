//
//  EndlessVC.swift
//  ListExample-iOS
//
//  Created by Mostafa Taghipour on 1/4/18.
//  Copyright © 2018 RainyDay. All rights reserved.
//

import RxGesture
import RxSwift
import UIKit

class SectionedVC: UIViewController {
    @IBOutlet var tableView: UITableView!

    var viewModel: SectionedVM!
    var bag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.backgroundColor
        title = "Sectioned"

        viewModel = SectionedVM()

        // config tableview
        tableView.register(UINib(nibName: MovieCell.className, bundle: nil), forCellReuseIdentifier: MovieCell.reuseIdentifier)
        tableView.register(UINib(nibName: SectionFooter.className, bundle: nil), forHeaderFooterViewReuseIdentifier: SectionFooter.reuseIdentifier)
        tableView.allowsSelection = false
        tableView.removeExtraLines()
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 125

        let adapter = SectionedAdapter(tableView: tableView)

        // bind tableview
        viewModel
            .items
            .asDriver()
            .drive(onNext: { movieSections in
                adapter.setData(newData: movieSections)
            })
            .disposed(by: bag)
    }
    
    
 
}
