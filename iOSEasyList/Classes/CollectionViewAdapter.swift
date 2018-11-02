//
//  CollectionViewUpdater.swift
//  ListExample-iOS
//
//  Created by Mostafa Taghipour on 1/18/18.
//  Copyright © 2018 RainyDay. All rights reserved.
//

import UIKit

open class CollectionViewAdapter : ListAdapter , UICollectionViewDataSource,UICollectionViewDelegate {
    
    //constructors
    public init(collectionView:UICollectionView,
                configCell : configCellType?=nil,
                didSelectItem : didSelectItemType?=nil) {
        super.init(listUpdater: CollectionViewUpdater(collectionView: collectionView))
        self.collectionView=collectionView
        self.collectionView?.delegate=self
        self.collectionView?.dataSource=self
        self.didSelectItem=didSelectItem
        
        if let configCell=configCell{
            self.configCell=configCell
        }
    }
    
    
    // variables
    public weak var collectionView :UICollectionView?
    
    public  typealias configCellType = (_ collectionView:UICollectionView,_ indexPath: IndexPath,_ data:Any?)->(UICollectionViewCell)
    public  var configCell:configCellType = {(_,_,_) in
        fatalError("Subclasses need to implement the configCell variable.")
    }
    
    public  typealias didSelectItemType = (_ data:Any?,_ indexPath:IndexPath)->()
    public var didSelectItem : didSelectItemType?
    
    internal override var emptyView:UIView?{
        didSet{
            guard let emptyView = emptyView else { return  }
            collectionView?.backgroundView=emptyView
            
        }
    }
    
    public override func getVisibleItems(in section: Int) -> [Any] {
        return collectionView?.indexPathsForVisibleItems.map{getItem(indexPath: $0)}.compactMap{$0} ?? []
    }
    
    public override func getVisibleItems<T>(in section: Int, itemType: T.Type) -> [T]? {
        return getVisibleItems(in: section) as? [T]
    }
    
    //MARK:- UICollectionViewDataSource,UICollectionViewDelegate
    open func numberOfSections(in collectionView: UICollectionView) -> Int {
        let count = sectionCount
        emptyView?.isHidden = count > 0
        return count
    }
    
    open func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let count = getItemCount(in: section)
        if let collapsible = self as? Collapsible{
            return collapsible.isCollapsed(section: section) ? 0 : count
        }
        
        return count
    }
    
    open func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return configCell(collectionView,indexPath,getItem(indexPath: indexPath))
    }
    
    open func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.didSelectItem?(getItem(indexPath: indexPath), indexPath)
    }
}

