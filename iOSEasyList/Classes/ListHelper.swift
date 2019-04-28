//
//  ListHelper.swift
//  ListExample-iOS
//
//  Created by Mostafa Taghipour on 1/5/18.
//  Copyright © 2018 RainyDay. All rights reserved.
//

import UIKit

extension UITableView{
    public func removeExtraLines(){
        tableFooterView = UIView()
    }
    
    
    public var rowCount:Int{
        
        var rows: Int = 0
        
        for i in 0..<numberOfSections {
            rows += numberOfRows(inSection: i)
        }
        
        return rows
    }
    
    public  var selectedRowCount:Int{
        return indexPathsForSelectedRows?.count ?? 0
    }
    
    
    public var isEmpty:Bool{
        return visibleCells.count < 1
    }
    
    
    public  func isIndexPathValid(indexPath:IndexPath)->Bool{
        return isSectionValid(section: indexPath.section) && isRowValid(section: indexPath.section,  row: indexPath.row)
    }
    
    public  func isSectionValid(section:Int)->Bool{
        return section >= 0 && section < numberOfSections
    }
    
    public  func isRowValid(section:Int=0,row:Int)->Bool{
        return row >= 0 && row < numberOfRows(inSection: section)
    }
    
}


extension UICollectionView{
    
    public var itemCount:Int{
        
        var rows: Int = 0
        
        for i in 0..<numberOfSections {
            rows += numberOfItems(inSection: i)
        }
        
        return rows
    }
    
    public  var selectedItemCount:Int{
        return indexPathsForSelectedItems?.count ?? 0
    }
    
    
    public  var isEmpty:Bool{
        return visibleCells.count < 1
    }
    
    
    public func isIndexPathValid(indexPath:IndexPath)->Bool{
        return isSectionValid(section: indexPath.section) && isRowValid(section: indexPath.section,  row: indexPath.row)
    }
    
    public func isSectionValid(section:Int)->Bool{
        return section >= 0 && section < numberOfSections
    }
    
    public func isRowValid(section:Int=0,row:Int)->Bool{
        return row >= 0 && row < numberOfItems(inSection:  section)
    }
    
}


extension Array {
    public  func grouped<T>(by criteria: (Element) -> T) -> [T: [Element]] {
        var groups = [T: [Element]]()
        for element in self {
            let key = criteria(element)
            if groups.keys.contains(key) == false {
                groups[key] = [Element]()
            }
            groups[key]?.append(element)
        }
        return groups
    }
}

extension Array where Element: Equatable {
    
    @discardableResult public mutating func remove(item: Element) -> Bool {
        if let index = firstIndex(of: item) {
            self.remove(at: index)
            return true
        }
        return false
    }
    
    @discardableResult public mutating func remove(where predicate: (Array.Iterator.Element) -> Bool) -> Bool {
        if let index = self.firstIndex(where: { (element) -> Bool in
            return predicate(element)
        }) {
            self.remove(at: index)
            return true
        }
        return false
    }
    
}


