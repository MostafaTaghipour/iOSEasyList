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
import iOSEasyList

class EndlessVC: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var loadingView: LoadingView!
    @IBOutlet weak var errorView: ErrorView!
    
    let refreshControl = UIRefreshControl()
    var viewModel:EndlessVM!
    var scrollListener : PaginatedTableScrollListener!
    var bag=DisposeBag()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.backgroundColor
        self.title="Pagination"
        self.navigationController?.navigationBar.prefersLargeTitles=true
        self.navigationItem.rightBarButtonItem=UIBarButtonItem(title: "Scroll Top", style: .plain, target: self, action: #selector(self.scrollTop))
        
        viewModel=EndlessVM()
        
        //config tableview
        tableView.refreshControl=refreshControl
        tableView.register(UINib(nibName: HeroCell.className, bundle: nil), forCellReuseIdentifier: HeroCell.reuseIdentifier)
        tableView.register(UINib(nibName: MovieCell.className, bundle: nil), forCellReuseIdentifier: MovieCell.reuseIdentifier)
        tableView.register(UINib(nibName: PopularCell.className, bundle: nil), forCellReuseIdentifier: PopularCell.reuseIdentifier)
        tableView.allowsSelection=false
        tableView.removeExtraLines()
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 125
        
        //setup adapter
        let adapter=EndlessAdapter(tableView: tableView)
        adapter.delegate=self
        
        //tableview scroll listener
        scrollListener =  PaginatedTableScrollListener(
            tableView: tableView,
            onLoadMore: { (page) in
                self.viewModel.loadTopMovies(page: page)
        },
            onPageChanged: { (currentPage) in
                print("current page: \(currentPage)")
        })
        
        scrollListener.pageSize=20
        
        //add footer view
        tableView.loadingFooterView=ProgressFooter(frame: CGRect(x: 0, y: 0, width: 0, height: 100))
        let retryFooter=RetryFooter(frame: CGRect(x: 0, y: 0, width: 0, height: 100))
        tableView.retryFooterView=retryFooter
        
        
        //bind tableview
        viewModel
            .items
            .asDriver()
            .drive(onNext: { (items) in
                adapter.setData(newData: items)
            })
            .disposed(by: bag)
        
        
        //reload data
        refreshControl
            .rx
            .controlEvent(.valueChanged)
            .subscribe(onNext: { _ in
                self.viewModel.loadTopMovies(page: 0,clearOld: true)
            })
            .disposed(by: bag)
        
        
        //handle loading
        viewModel
            .loading
            .asDriver()
            .drive(onNext: { (loading) in
                
                if self.tableView.isEmpty{
                    self.loadingView.isHidden = !loading
                    self.loadingView.activityIndicator.animating = loading
                }
                else if self.refreshControl.isRefreshing && !loading{
                    self.refreshControl.endRefreshing()
                    
                    self.scrollListener.reset()
                }
                else{
                    self.tableView.loadingFooter=loading
                    (self.tableView.tableFooterView as? ProgressFooter)?.activityIndicator.animating=loading
                }
            })
            .disposed(by: bag)
        
        
        //handle error
        viewModel
            .error
            .asDriver()
            .drive(onNext: { (error) in
                
                let hasError = error != nil
                
                if self.tableView.isEmpty{
                    self.errorView.isHidden = !hasError
                    self.errorView.errorCause.text=error
                }
                else{
                    self.tableView.retryFooter=hasError
                    (self.tableView.tableFooterView as? RetryFooter)?.loadMoreErrorText.text = error
                }
            })
            .disposed(by: bag)
        
        
        //handle retry
        errorView
            .retryButton
            .rx
            .tap
            .asObservable()
            .bind(onNext: loadNextPage)
            .disposed(by: bag)
        
        retryFooter
            .rx
            .tapGesture()
            .when(.recognized)
            .subscribe(onNext: { [weak self] (_) in
                self?.loadNextPage()
            })
            .disposed(by: bag)
        
    }
    
    private func loadNextPage() {
        viewModel.loadTopMovies(page: scrollListener.lastLoadedPage)
    }
    
    @objc func scrollTop(){
        tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top , animated: true)
    }
}


extension EndlessVC:EndlessAdapterDelegate{
    func scrollViewDidScroll(scrollView: UIScrollView) {
        scrollListener.scrollViewDidScroll(scrollView)
    }
}



