//
//  PaginatedTableScrollListener.swift
//  ListExample-iOS
//
//  Created by Mostafa Taghipour on 1/5/18.
//  Copyright © 2018 RainyDay. All rights reserved.
//

import UIKit


open class PaginatedListScrollListener:NSObject,UIScrollViewDelegate{
    
    public typealias onPageChangedClosure = (_ currentPage:Int)->()
    public typealias onLoadMoreClosure = (_ page:Int)->()
    
    
    var onLoadMore:onLoadMoreClosure?
    var onPageChanged:onPageChangedClosure?
    
    var previousTotal = 0 // The total number of _allItems in the dataset after the last load
    var loading = true // True if we are still waiting for the last set of data to load.
    
    public var visibleThreshold = 5 // The minimum amount of _allItems to have below your current scroll position before loading more.
    public private(set) var lastLoadedPage = 0
    public private(set) var currentPage = 0
    public var pageSize: Int? = nil
    
    
    var visibleItemCount :Int{
        fatalError("Subclasses need to implement the this variable.")
    }
    
    var totalItemCount :Int{
        fatalError("Subclasses need to implement the this variable.")
    }
    
    var firstVisibleItem :Int{
        fatalError("Subclasses need to implement the this variable.")
    }
    
    var lastVisibleItem :Int{
        fatalError("Subclasses need to implement the this variable.")
    }
    
    public init(onLoadMore:@escaping onLoadMoreClosure,
                onPageChanged:onPageChangedClosure?=nil) {
        
        
        self.onLoadMore=onLoadMore
        self.onPageChanged=onPageChanged
    }
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if let pageSize = self.pageSize , (lastVisibleItem / pageSize) != currentPage {
            currentPage = (lastVisibleItem / pageSize)
            self.onPageChanged?(currentPage)
        }
        
      
        if (loading && (totalItemCount > previousTotal)) {
                loading = false
                previousTotal = totalItemCount
        }
        if (!loading && (totalItemCount - visibleItemCount <= firstVisibleItem + visibleThreshold)) {
            // End has been reached
            lastLoadedPage = lastLoadedPage + 1
            self.onLoadMore?(lastLoadedPage)
            loading = true
        }
    }
    
    
    public func reset() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { [weak self] in
            self?.previousTotal = 0
            self?.loading = true
            self?.currentPage=0
            self?.lastLoadedPage=0
        }
    }
}

public class PaginatedTableScrollListener:PaginatedListScrollListener{
    
    private weak var tableView:UITableView?
    
    override var visibleItemCount: Int{
        return self.tableView?.visibleCells.count ?? 0
    }
    
    override var totalItemCount: Int{
        return self.tableView?.rowCount ?? 0
    }
    
    override var firstVisibleItem: Int {
        return tableView?.indexPathsForVisibleRows?.first?.row ?? 0
    }
    
    override var lastVisibleItem: Int{
        return  tableView?.indexPathsForVisibleRows?.last?.row ?? 0
    }
    
    public init(tableView:UITableView,
                onLoadMore:@escaping onLoadMoreClosure,
                onPageChanged:onPageChangedClosure?=nil) {
        super.init(onLoadMore: onLoadMore, onPageChanged: onPageChanged)
        self.tableView=tableView
    }
}


public class PaginatedCollectionScrollListener:PaginatedListScrollListener{
    
    private weak var collectionView:UICollectionView?
    
    override var visibleItemCount: Int{
        return self.collectionView?.visibleCells.count ?? 0
    }
    
    override var totalItemCount: Int{
        return self.collectionView?.itemCount ?? 0
    }
    
    override var firstVisibleItem: Int {
        return collectionView?.indexPathsForVisibleItems.first?.row ?? 0
    }
    
    override var lastVisibleItem: Int{
        return  collectionView?.indexPathsForVisibleItems.last?.row ?? 0
    }
    
    public init(collectionView:UICollectionView,
                onLoadMore:@escaping onLoadMoreClosure,
                onPageChanged:onPageChangedClosure?=nil) {
        super.init(onLoadMore: onLoadMore, onPageChanged: onPageChanged)
        self.collectionView=collectionView
    }
}


