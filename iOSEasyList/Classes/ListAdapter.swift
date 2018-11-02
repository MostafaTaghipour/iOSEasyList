//
//  BaseAdapter.swift
//  AKMaskField
//
//  Created by Remote User on 1/30/18.
//

import UIKit

open class ListAdapter : NSObject{
    
    // variables
    var _private_originalItems:[Any]?
    var _private_collapseSections:[Int]=[Int]()
    var _private_lockNoneFilteredItems=false
    
    
    var emptyView:UIView?
    var listUpdater:ListUpdater!
    
    public  var animationConfig:AnimationConfig?{
        didSet{
            guard let config = animationConfig else { return  }
            listUpdater.animationConfig=config
        }
    }
    public var isAnimationEnable:Bool=true{
        didSet{
            listUpdater.isAnimationEnable = isAnimationEnable
        }
    }
    
    public var sectionCount: Int {
        return listUpdater.dataSource.count
    }
    
    public var itemCount: Int{
        return listUpdater.dataSource.map{$0.items.count}.reduce(0, +)
    }
    
    public var isEmpty: Bool{
        return itemCount == 0
    }
    
    init(listUpdater:ListUpdater) {
        self.listUpdater=listUpdater
    }
    
    // setters
    public func setData(newData:[Any]?,animated:Bool=true){
        if let filterable = self as? Filterable{
            filterable.setData(newData: newData)
        }
        
        if let colapsible = self as? Collapsible,let sections = newData as? [Section]{
            colapsible.setData(newData: sections)
        }
        
        listUpdater.reload(newData: newData ?? [Any](), animated: animated)
    }
    
    public func setEmptyView(emptyView:UIView){
        self.emptyView=emptyView
    }
    
    public func setEmptyView(fromNib name: String) {
        guard let view = Bundle.main.loadNibNamed(name, owner: nil, options: nil)?.first as? UIView else {
            fatalError("Could not load view from nib with name \(name)")
        }
        
        self.emptyView=view
    }
    
    
    // getters
    public func getSections()->[Section]{
        return listUpdater.dataSource
    }
    
    public func getSections<T>(itemType: T.Type)->[T]?{
        return getSections() as? [T]
    }
    
    public func getSection(section:Int)->Section?{
        guard getSections().indices.contains(section) else {
            return nil
        }
        return  getSections()[section]
    }
    
    public func getSection<T>(section:Int, itemType: T.Type)->T?{
        return getSection(section: section) as? T
    }
    
    public func getItems(in section:Int=0)->[Any]{
        return getSection(section: section)?.items ?? []
    }
    
    public func getItems<T>(in section:Int=0,itemType: T.Type)->[T]?{
        return getItems(in: section) as? [T]
    }
    
    public func getVisibleItems(in section:Int=0)->[Any]{
        return []
    }
    
    public func getVisibleItems<T>(in section:Int=0,itemType: T.Type)->[T]?{
        return []
    }
    
    public func getItem(indexPath:IndexPath)->Any?{
        
        guard let section = getSection(section: indexPath.section),
            section.items.indices.contains(indexPath.item)
            else { return nil }
        
        return section.items[indexPath.item]
    }
    
    public func getItem<T>(indexPath:IndexPath, itemType: T.Type)->T?{
        return getItem(indexPath: indexPath) as? T
    }
    
    public func getItemCount(in section:Int = 0)->Int{
        return getItems(in: section).count
    }
    
    
    // functions
    public func reloadData(animated:Bool=true){
        setData(newData: getSections(),animated:animated)
    }
    
    func insertSection(at section: Int, with animation: UITableView.RowAnimation = .automatic){
        listUpdater.notifyInsertSections(at: IndexSet([section]), with: animation)
    }
    func deleteSection(at section: Int, with animation: UITableView.RowAnimation = .automatic){
        listUpdater.notifyDeleteSections(at: IndexSet([section]), with: animation)
    }
    func reloadSection(at section: Int, with animation: UITableView.RowAnimation = .automatic){
        listUpdater.notifyReloadSections(at: IndexSet([section]), with: animation)
    }
    func insertSections(at sections: IndexSet, with animation: UITableView.RowAnimation = .automatic){
        listUpdater.notifyInsertSections(at: sections, with: animation)
    }
    func deleteSections(at sections: IndexSet, with animation: UITableView.RowAnimation = .automatic){
        listUpdater.notifyDeleteSections(at: sections, with: animation)
    }
    func reloadSections(at sections: IndexSet, with animation: UITableView.RowAnimation = .automatic){
        listUpdater.notifyReloadSections(at: sections, with: animation)
    }
    func moveSection(at section: Int, to newSection: Int){
        listUpdater.notifyMoveSection(at: section, to: newSection)
    }
    func insertItem(at indexPath: IndexPath, with animation: UITableView.RowAnimation = .automatic){
        listUpdater.notifyInsertItems(at: [indexPath], with: animation)
    }
    func deleteItem(at indexPath: IndexPath, with animation: UITableView.RowAnimation = .automatic){
        listUpdater.notifyDeleteItems(at: [indexPath], with: animation)
    }
    func reloadItem(at indexPath: IndexPath, with animation: UITableView.RowAnimation = .automatic){
        listUpdater.notifyReloadItems(at: [indexPath], with: animation)
    }
    func insertItems(at indexPaths: [IndexPath], with animation: UITableView.RowAnimation = .automatic){
        listUpdater.notifyInsertItems(at: indexPaths, with: animation)
    }
    func deleteItems(at indexPaths: [IndexPath], with animation: UITableView.RowAnimation = .automatic){
        listUpdater.notifyDeleteItems(at: indexPaths, with: animation)
    }
    func reloadItems(at indexPaths: [IndexPath], with animation: UITableView.RowAnimation = .automatic){
        listUpdater.notifyReloadItems(at: indexPaths, with: animation)
    }
    func moveItem(at indexPath: IndexPath, to newIndexPath: IndexPath){
        listUpdater.notifyMoveItem(at: indexPath, to: newIndexPath)
    }
}

