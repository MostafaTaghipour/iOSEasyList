//
//  ListUpdater.swift
//  ListUpdater
//
//  Created by Joe's MacBook Pro on 2017/7/9.
//  Copyright © 2017年 joe. All rights reserved.
//

import UIKit

let defaultThrottle : Float = 0.1

class ListUpdater {
    
    fileprivate(set) var dataSource = [Section]()
    private let throttle = ThrottleTask(throttle: defaultThrottle)
    
    public var isAnimationEnable:Bool=true
    
    var animationConfig=AnimationConfig(reload: .fade, insert: .top, delete: .top)
    
    fileprivate func update(dataSource:[SectionDiffable], animation:@escaping ((DiffIndexResult, DiffSectionResult)) -> Void) -> Void {
        throttle.add {
            
            let diff = sectionedDiff(from:self.dataSource as! Array<SectionDiffable>, to: dataSource)
            self.dataSource = dataSource
            DispatchQueue.main.sync {
                animation(diff)
            }
        }
        
    }
    
    // reload
    func reload(newData:[Any],animated:Bool=true) -> Void {
        
        if newData.isEmpty{
            if dataSource.isEmpty{
                return
            }
            
            if dataSource is [SectionDiffable], let sections = newData as? [SectionDiffable]{
                reload(sections: sections, animated: animated)
            }
                
            else if let sections = newData as? [Section]{
                immedateReload(sections: sections)
            }
            return
        }
        
        if let sections=newData as? [SectionDiffable]{
            reload(sections: sections, animated: animated)
        }
        else if let rows=newData as? [Diffable]{
            reload(items: rows, animated: animated)
        }
        else{
            immedateReload(newData: newData)
        }
    }
    
    func reload(items:[Diffable],animated:Bool=true) -> Void {
        if animated{
            animateReload(items: items)
        }
        else{
            immedateReload(items: items)
        }
    }
    
    func reload(sections:[SectionDiffable],animated:Bool=true) -> Void {
        if animated{
            animateReload(sections: sections)
        }
        else{
            immedateReload(sections: sections)
        }
    }
    
    
    // animateReload
    func animateReload(newData:[Any]) -> Void {
        
        if newData.isEmpty{
            if dataSource.isEmpty{
                return
            }
            
            if !(dataSource is [SectionDiffable]) , let sections = newData as? [Section]{
                immedateReload(sections: sections)
                return
            }
        }
        
        if let sections=newData as? [SectionDiffable]{
            animateReload(sections: sections)
        }
        else if let rows=newData as? [Diffable]{
            animateReload(items: rows)
        }
        else{
            immedateReload(newData: newData)
        }
    }
    
    func animateReload(items:[Diffable]) -> Void {
        self.animateReload(sections: [SingleSectionDiffable(items: items)])
    }
    
    
    // immedateReload
    func immedateReload(newData:[Any]) -> Void {
        if let sections=newData as? [SectionDiffable]{
            immedateReload(sections: sections)
        }
        else if let rows=newData as? [Diffable]{
            immedateReload(items: rows)
        }
        else if let sections = newData as? [Section]{
            immedateReload(sections: sections)
        }
        else{
            immedateReload(sections: [SingleSection(items: newData)])
        }
    }
    
    func immedateReload(items:[Diffable]) -> Void {
        immedateReload(sections: [SingleSectionDiffable(items: items)])
    }
    
    
    //Must Implement
    func animateReload(sections:[SectionDiffable]) -> Void {}
    func immedateReload(sections:[Section]) -> Void {  }
    
    func notifyInsertSections(at sections: IndexSet, with animation: UITableView.RowAnimation){}
    func notifyDeleteSections(at sections: IndexSet, with animation: UITableView.RowAnimation){}
    func notifyReloadSections(at sections: IndexSet, with animation: UITableView.RowAnimation){}
    func notifyMoveSection(at section: Int, to newSection: Int){}
    func notifyInsertItems(at indexPaths: [IndexPath], with animation: UITableView.RowAnimation){}
    func notifyDeleteItems(at indexPaths: [IndexPath], with animation: UITableView.RowAnimation){}
    func notifyReloadItems(at indexPaths: [IndexPath], with animation: UITableView.RowAnimation){}
    func notifyMoveItem(at IndexPathindexPath: IndexPath, to newIndexPath: IndexPath){}
    
}

class TableViewUpdater: ListUpdater {
    weak var tableView:UITableView?
    
    
    init(tableView:UITableView,animationConfig:AnimationConfig? = nil) {
        super.init()
        self.tableView = tableView
        
        if let animConfig = animationConfig {
            self.animationConfig=animConfig
        }
    }
    
    
    
    override func animateReload(sections:[SectionDiffable]) -> Void {
        if self.tableView?.window == nil || !isAnimationEnable {
            self.immedateReload(sections: sections)
            return
        }
        self.update(dataSource: sections) {[weak self] (result) in
            
            guard let uwSelf = self , let tableView=self?.tableView else{
                return
            }
            
            tableView.beginUpdates()
            let indexDiff = result.0
            let sectionDiff = result.1
            tableView.deleteSections(indexDiff.deletes, with: uwSelf.animationConfig.delete)
            tableView.insertSections(indexDiff.inserts, with: uwSelf.animationConfig.insert)
            tableView.reloadSections(indexDiff.reloads, with: uwSelf.animationConfig.reload)
            for move in indexDiff.moveIndexes {
                tableView.moveSection(move.from, toSection: move.to)
            }
            tableView.deleteRows(at: sectionDiff.deletes, with: uwSelf.animationConfig.delete)
            tableView.insertRows(at: sectionDiff.inserts, with: uwSelf.animationConfig.insert)
            tableView.reloadRows(at: sectionDiff.reloads, with: uwSelf.animationConfig.reload)
            for move in sectionDiff.moveRows {
                tableView.moveRow(at: move.from, to: move.to)
            }
            tableView.endUpdates()
        }
    }
    
    override func immedateReload(sections:[Section]) -> Void {
        self.dataSource = sections
        self.tableView?.reloadData()
    }
    
    override func notifyInsertSections(at sections: IndexSet, with animation: UITableView.RowAnimation = .automatic){
        tableView?.insertSections(sections, with: animation)
    }
    override func notifyDeleteSections(at sections: IndexSet, with animation: UITableView.RowAnimation = .automatic){
        tableView?.deleteSections(sections, with: animation)
    }
    override func notifyReloadSections(at sections: IndexSet, with animation: UITableView.RowAnimation = .automatic){
        tableView?.reloadSections(sections, with: animation)
    }
    override func notifyMoveSection(at section: Int, to newSection: Int){
        tableView?.moveSection(section, toSection: newSection)
    }
    override func notifyInsertItems(at indexPaths: [IndexPath], with animation: UITableView.RowAnimation = .automatic){
        tableView?.insertRows(at: indexPaths, with: animation)
    }
    override func notifyDeleteItems(at indexPaths: [IndexPath], with animation: UITableView.RowAnimation = .automatic){
        tableView?.deleteRows(at: indexPaths, with: animation)
    }
    override func notifyReloadItems(at indexPaths: [IndexPath], with animation: UITableView.RowAnimation = .automatic){
        tableView?.reloadRows(at: indexPaths, with: animation)
    }
    override func notifyMoveItem(at indexPath: IndexPath, to newIndexPath: IndexPath){
        tableView?.moveRow(at: indexPath, to: newIndexPath)
    }
    
}

class CollectionViewUpdater: ListUpdater {
    
    weak var collectionView:UICollectionView?
    
    init(collectionView:UICollectionView) {
        self.collectionView = collectionView
    }
    
    override func animateReload(sections:[SectionDiffable]) -> Void {
        if self.collectionView?.window == nil || !isAnimationEnable {
            self.immedateReload(sections: sections)
            return
        }
        self.update(dataSource: sections) { (result) in
            self.collectionView?.performBatchUpdates({
                let indexDiff = result.0
                let sectionDiff = result.1
                self.collectionView?.deleteSections(indexDiff.deletes)
                self.collectionView?.insertSections(indexDiff.inserts)
                self.collectionView?.reloadSections(indexDiff.reloads)
                for move in indexDiff.moveIndexes {
                    self.collectionView?.moveSection(move.from, toSection: move.to)
                }
                self.collectionView?.deleteItems(at: sectionDiff.deletes)
                self.collectionView?.insertItems(at: sectionDiff.inserts)
                self.collectionView?.reloadItems(at: sectionDiff.reloads)
                for move in sectionDiff.moveRows {
                    self.collectionView?.moveItem(at: move.from, to: move.to)
                }
            }, completion: nil)
        }
    }
    
    
    override func immedateReload(sections:[Section]) -> Void {
        self.dataSource = sections
        self.collectionView?.reloadData()
    }
    
    
    override func notifyInsertSections(at sections: IndexSet, with animation: UITableView.RowAnimation){
        collectionView?.insertSections(sections)
    }
    override func notifyDeleteSections(at sections: IndexSet, with animation: UITableView.RowAnimation){
        collectionView?.deleteSections(sections)
    }
    override func notifyReloadSections(at sections: IndexSet, with animation: UITableView.RowAnimation){
        collectionView?.reloadSections(sections)
    }
    override func notifyMoveSection(at section: Int, to newSection: Int){
        collectionView?.moveSection(section, toSection: newSection)
    }
    override func notifyInsertItems(at indexPaths: [IndexPath], with animation: UITableView.RowAnimation){
        collectionView?.insertItems(at: indexPaths)
    }
    override func notifyDeleteItems(at indexPaths: [IndexPath], with animation: UITableView.RowAnimation){
        collectionView?.deleteItems(at: indexPaths)
    }
    override func notifyReloadItems(at indexPaths: [IndexPath], with animation: UITableView.RowAnimation){
        collectionView?.reloadItems(at: indexPaths)
    }
    override func notifyMoveItem(at indexPath: IndexPath, to newIndexPath: IndexPath){
        collectionView?.moveItem(at: indexPath, to: newIndexPath)
    }
}




class ThrottleTask {
    
    typealias Task = () -> Void
    
    private var throttle:Float = 0.0
    private var tasks = [Task]()
    private let queue = DispatchQueue(label: "throttle.task.serial.queue", attributes: .init(rawValue:0))
    
    init(throttle:Float) {
        self.throttle = throttle
    }
    
    func add(task:@escaping Task) -> Void {
        objc_sync_enter(self)
        self.tasks.append(task)
        if self.tasks.count == 1 {
            self.execute()
        }
        objc_sync_exit(self)
    }
    
    func execute() -> Void {
        queue.asyncAfter(deadline: DispatchTime.now() + DispatchTimeInterval.milliseconds(Int(self.throttle * 1000.0))) {
            objc_sync_enter(self)
            guard let task = self.tasks.last else { return }
            self.tasks.removeAll()
            objc_sync_exit(self)
            task()
        }
    }
    
}



public struct AnimationConfig {
    let reload : UITableView.RowAnimation
    let insert : UITableView.RowAnimation
    let delete : UITableView.RowAnimation
    
    public init( reload : UITableView.RowAnimation,
                 insert : UITableView.RowAnimation,
                 delete : UITableView.RowAnimation) {
        self.reload = reload
        self.insert=insert
        self.delete=delete
    }
    
}



struct SingleSection: Section {
    var items: Array<Any>
}

struct SingleSectionDiffable : SectionDiffable {
    
    var diffIdentifier: String = ""
    
    var diffableItems: Array<Diffable> = [Diffable]()
    
    init(items:[Diffable]) {
        self.diffableItems=items
    }
}

