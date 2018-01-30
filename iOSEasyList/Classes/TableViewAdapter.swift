//
//  TableViewAdapter.swift
//  ListExample-iOS
//
//  Created by Mostafa Taghipour on 1/12/18.
//  Copyright © 2018 RainyDay. All rights reserved.
//

import UIKit

open class TableViewAdapter : ListAdapter , UITableViewDataSource,UITableViewDelegate {
    
    // constructors
    public init(tableView:UITableView,
                configCell : configCellType?=nil,
                didSelectItem : didSelectItemType?=nil) {
        super.init()
        self.tableView=tableView
        self.tableView?.delegate=self
        self.tableView?.dataSource=self
        self.tableViewUpdater=TableViewUpdater(tableView: tableView)
        self.didSelectItem=didSelectItem
        
        if let configCell=configCell{
            self.configCell=configCell
        }
    }
    
    
    // variables
    public weak var tableView :UITableView?
    private var tableViewUpdater : TableViewUpdater?
    public  var animationConfig:AnimationConfig?{
        didSet{
            guard let config = animationConfig else { return  }
            tableViewUpdater?.animationConfig=config
        }
    }
    override public var isAnimationEnable:Bool{
        didSet{
            tableViewUpdater?.isAnimationEnable = isAnimationEnable
        }
    }
    
    public  typealias configCellType = (_ tableView:UITableView,_ indexPath: IndexPath,_ data:Any?)->(UITableViewCell)
    public  var configCell:configCellType = {(_,_,_) in
        fatalError("Subclasses need to implement the configCell variable.")
    }
    
    public  typealias didSelectItemType = (_ data:Any?,_ indexPath:IndexPath)->()
    public var didSelectItem : didSelectItemType?
    
    internal override var emptyView:UIView?{
        didSet{
            guard let emptyView = emptyView else { return  }
            tableView?.backgroundView=emptyView
            
        }
    }
    
    
    
    // setters
    public override func setData(newData:[Any]?,animated:Bool=true){
        super.setData(newData: newData)
        tableViewUpdater?.reload(newData: newData ?? [Any](), animated: animated)
    }
    
    
    // getters
    public override func getData()->[Any]{
        guard let dataSource = tableViewUpdater?.dataSource , !dataSource.isEmpty else {
            return []
        }
        
        return dataSource.count > 1 ? dataSource : dataSource[0].sectionItems
    }
    
    public override func getData<T>(itemType: T.Type)->[T]?{
        return getData() as? [T]
    }
    
    public override func getItem(indexPath:IndexPath)->Any?{
        guard let tableView = self.tableView ,
            tableView.isIndexPathValid(indexPath: indexPath),
            let updater = tableViewUpdater else { return nil }
        
        return  updater.dataSource[indexPath.section].sectionItems[indexPath.row] 
    }
    
    public override func getItem<T>(indexPath:IndexPath, itemType: T.Type)->T?{
        return getItem(indexPath: indexPath) as? T
    }
    
    public override func getSection(section:Int)->Any?{
        guard let tableView = self.tableView ,
            tableView.isSectionValid(section: section),
            let updater = tableViewUpdater else { return nil }
        
        return  updater.dataSource[section]
    }
    
    public override func getSection<T>(section:Int, itemType: T.Type)->T?{
        return getSection(section: section) as? T
    }
    
    
    
    //MARK:- UITableViewDataSource,UITableViewDelegate
    open func numberOfSections(in tableView: UITableView) -> Int {
        let count = self.tableViewUpdater?.dataSource.count ?? 0
        emptyView?.isHidden = count > 0
        return count
    }
    
    open func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let updater = self.tableViewUpdater ,
            updater.dataSource.indices.contains(section)
            else {
                return 0
        }
        
        return  updater.dataSource[section].sectionItems.count
    }
    
    open func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return configCell(tableView,indexPath,getItem(indexPath: indexPath))
    }
    
    open func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.didSelectItem?(getItem(indexPath: indexPath), indexPath)
    }
}





