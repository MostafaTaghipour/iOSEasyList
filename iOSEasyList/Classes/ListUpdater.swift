//
//  ListUpdater.swift
//  ListUpdater
//
//  Created by Joe's MacBook Pro on 2017/7/9.
//  Copyright © 2017年 joe. All rights reserved.
//

import UIKit

let defaultThrottle : Float = 0.1

public class ListUpdater {
    
    public fileprivate(set) var dataSource = [SectionDiffable]()
    private let throttle = ThrottleTask(throttle: defaultThrottle)
    
    public var isAnimationEnable:Bool=true
    
    fileprivate func update(dataSource:[SectionDiffable], animation:@escaping ((DiffIndexResult, DiffSectionResult)) -> Void) -> Void {
        throttle.add {
            let diff = sectionedDiff(from: self.dataSource, to: dataSource)
            self.dataSource = dataSource
            DispatchQueue.main.sync {
                animation(diff)
            }
        }
        
    }
    
}

public class TableViewUpdater: ListUpdater {
    public weak var tableView:UITableView?
    public var animationConfig=AnimationConfig(reload: .fade, insert: .top, delete: .top)
    
    public init(tableView:UITableView,animationConfig:AnimationConfig? = nil) {
        self.tableView = tableView
        
        if let animConfig = animationConfig {
            self.animationConfig=animConfig
        }
    }
    
    
    // reload
    public func reload(newData:[Any],animated:Bool=true) -> Void {
        if let sections=newData as? [SectionDiffable]{
            reload(sections: sections, animated: animated)
        }
        else if let rows=newData as? [Diffable]{
            reload(rows: rows, animated: animated)
        }
    }
    
    public func reload(rows:[Diffable],animated:Bool=true) -> Void {
        if animated{
            animateReload(rows: rows)
        }
        else{
            immedateReload(rows: rows)
        }
    }
    
    public func reload(sections:[SectionDiffable],animated:Bool=true) -> Void {
        if animated{
            animateReload(sections: sections)
        }
        else{
            immedateReload(sections: sections)
        }
    }
    
    
    // animateReload
    public func animateReload(newData:[Any]) -> Void {
        if let sections=newData as? [SectionDiffable]{
            animateReload(sections: sections)
        }
        else if let rows=newData as? [Diffable]{
            animateReload(rows: rows)
        }
    }
    
    public func animateReload(rows:[Diffable]) -> Void {
        self.animateReload(sections: [SingleSection(items: rows)])
    }
    
    public func animateReload(sections:[SectionDiffable]) -> Void {
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
    
    
    // immedateReload
    public func immedateReload(newData:[Any]) -> Void {
        if let sections=newData as? [SectionDiffable]{
            immedateReload(sections: sections)
        }
        else if let rows=newData as? [Diffable]{
            immedateReload(rows: rows)
        }
    }
    
    public func immedateReload(rows:[Diffable]) -> Void {
        immedateReload(sections: [SingleSection(items: rows)])
    }
    
    public func immedateReload(sections:[SectionDiffable]) -> Void {
        self.dataSource = sections
        self.tableView?.reloadData()
    }
    
}

public class CollectionViewUpdater: ListUpdater {
    
    public weak var collectionView:UICollectionView?
    
    public init(collectionView:UICollectionView) {
        self.collectionView = collectionView
    }
    
    // reload
    public func reload(newData:[Any],animated:Bool=true) -> Void {
        if let sections=newData as? [SectionDiffable]{
            reload(sections: sections, animated: animated)
        }
        else if let items=newData as? [Diffable]{
            reload(items: items, animated: animated)
        }
    }
    
    public func reload(items:[Diffable],animated:Bool=true) -> Void {
        if animated{
            animateReload(items: items)
        }
        else{
            immedateReload(items: items)
        }
    }
    
    public func reload(sections:[SectionDiffable],animated:Bool=true) -> Void {
        if animated{
            animateReload(sections: sections)
        }
        else{
            immedateReload(sections: sections)
        }
    }
    
    // animateReload
    public func animateReload(newData:[Any]) -> Void {
        if let sections=newData as? [SectionDiffable]{
            animateReload(sections: sections)
        }
        else if let items=newData as? [Diffable]{
            animateReload(items: items)
        }
    }
    
    public func animateReload(items:[Diffable]) -> Void {
        self.animateReload(sections: [SingleSection(items: items)])
    }
    
    
    public func animateReload(sections:[SectionDiffable]) -> Void {
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
    
    // immedateReload
    public func immedateReload(newData:[Any]) -> Void {
        if let sections=newData as? [SectionDiffable]{
            immedateReload(sections: sections)
        }
        else if let items=newData as? [Diffable]{
            immedateReload(items: items)
        }
    }
    
    public func immedateReload(items:[Diffable]) -> Void {
        immedateReload(sections: [SingleSection(items: items)])
    }
    
    public func immedateReload(sections:[SectionDiffable]) -> Void {
        self.dataSource = sections
        self.collectionView?.reloadData()
    }
}




class ThrottleTask {
    
    public typealias Task = () -> Void
    
    private var throttle:Float = 0.0
    private var tasks = [Task]()
    private let queue = DispatchQueue(label: "throttle.task.serial.queue", attributes: .init(rawValue:0))
    
    public init(throttle:Float) {
        self.throttle = throttle
    }
    
    public func add(task:@escaping Task) -> Void {
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
    let reload : UITableViewRowAnimation
    let insert : UITableViewRowAnimation
    let delete : UITableViewRowAnimation
    
    public init( reload : UITableViewRowAnimation,
                 insert : UITableViewRowAnimation,
                 delete : UITableViewRowAnimation) {
        self.reload = reload
        self.insert=insert
        self.delete=delete
    }
    
}
