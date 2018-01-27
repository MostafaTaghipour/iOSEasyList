//
//  CollectionViewUpdater.swift
//  ListExample-iOS
//
//  Created by Mostafa Taghipour on 1/18/18.
//  Copyright © 2018 RainyDay. All rights reserved.
//

import UIKit

open class CollectionViewAdapter : NSObject , UICollectionViewDataSource,UICollectionViewDelegate {
    
    //constructors
    public init(collectionView:UICollectionView) {
        super.init()
        self.collectionView=collectionView
        self.collectionView?.delegate=self
        self.collectionView?.dataSource=self
        self.collectionViewUpdater=CollectionViewUpdater(collectionView: collectionView)
    }
    
    public  convenience init(collectionView:UICollectionView,
                             configCell : @escaping configCellType,
                             didSelectItem : @escaping didSelectItemType) {
        
        self.init(collectionView: collectionView, configCell: configCell)
        self.didSelectItem=didSelectItem
        
    }
    
    public  convenience init(collectionView:UICollectionView,
                             configCell : @escaping configCellType) {
        
        self.init(collectionView: collectionView)
        self.configCell=configCell
    }
    
    
    // variables
    public weak var collectionView :UICollectionView?
    private var collectionViewUpdater : CollectionViewUpdater?
   
    public var isAnimationEnable:Bool=true{
        didSet{
            collectionViewUpdater?.isAnimationEnable = isAnimationEnable
        }
    }
    
    public  typealias configCellType = (_ collectionView:UICollectionView,_ indexPath: IndexPath,_ data:Any?)->(UICollectionViewCell)
    public  var configCell:configCellType = {(_,_,_) in
        fatalError("Subclasses need to implement the configCell variable.")
    }
    
    public  typealias didSelectItemType = (_ data:Any?,_ indexPath:IndexPath)->()
    public var didSelectItem : didSelectItemType?
    
    public  var emptyView:UIView?{
        didSet{
            guard let emptyView = emptyView else { return  }
            collectionView?.backgroundView=emptyView
            
        }
    }
    
    
    
    // setters
    public func setData(newData:[Any]?,animated:Bool=true){
        collectionViewUpdater?.reload(newData: newData ?? [Any](), animated: animated)
    }
    
    // getters
    public func getData()->[Any]{
        guard let dataSource = collectionViewUpdater?.dataSource , !dataSource.isEmpty else {
            return []
        }
        
        return dataSource.count > 1 ? dataSource : dataSource[0].sectionItems
    }
    
    public func getData<T>(itemType: T.Type)->[T]?{
        return getData() as? [T]
    }
    
    public func getItem(indexPath:IndexPath)->Any?{
        guard let collectionView = self.collectionView ,
            collectionView.isIndexPathValid(indexPath: indexPath),
            let updater = collectionViewUpdater else { return nil }
        
        return  updater.dataSource[indexPath.section].sectionItems[indexPath.row]
    }
    
    public func getItem<T>(indexPath:IndexPath, itemType: T.Type)->T?{
        return getItem(indexPath: indexPath) as? T
    }
    
    public func getSection(section:Int)->Any?{
        guard let collectionView = self.collectionView ,
            collectionView.isSectionValid(section: section),
            let updater = collectionViewUpdater else { return nil }
        
        return  updater.dataSource[section]
    }
    
    public func getSection<T>(section:Int, itemType: T.Type)->T?{
        return getSection(section: section) as? T
    }
    
    
    //MARK:- UICollectionViewDataSource,UICollectionViewDelegate
    open func numberOfSections(in collectionView: UICollectionView) -> Int {
        let count = self.collectionViewUpdater?.dataSource.count ?? 0
        emptyView?.isHidden = count > 0
        return count
    }
    
    open func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let updater = self.collectionViewUpdater ,
            updater.dataSource.indices.contains(section)
            else {
                return 0
        }
        
        return  updater.dataSource[section].sectionItems.count
    }
    
    open func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return configCell(collectionView,indexPath,getItem(indexPath: indexPath))
    }
    
    open func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.didSelectItem?(getItem(indexPath: indexPath), indexPath)
    }
}
