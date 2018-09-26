//
//  Filterable.swift
//  AKMaskField
//
//  Created by Remote User on 1/30/18.
//

import Foundation

public protocol Collapsible {
    var type : CollapseType {get}
    var collapseByDefault:Bool {get}
}

public extension Collapsible{
    private var adapter:ListAdapter{
        guard let adapter = self as? ListAdapter else {
            fatalError("Collapsible must implemment by ListAdapter")
        }
        
        return adapter
    }
    internal func setData(newData:[Section]?){
        guard let sections=newData,!sections.isEmpty else {
            adapter._private_collapseSections = []
            return
        }
        
        if type == .normal {
            
            if collapseByDefault{
                adapter._private_collapseSections = sections
                    .enumerated()
                    .map{$0.offset}
            }
        }
        else{
            adapter._private_collapseSections = sections
                .enumerated()
                .map{$0.offset}
                .filter{$0 != 0}
        }
    }
    
    var type : CollapseType {
        get{
            return .normal
        }
    }
    var collapseByDefault:Bool {
        get{
            return true
        }
    }
    
    func collapse(section:Int){
        if (section >= adapter.sectionCount) || isCollapsed(section: section){
            return
        }
        
        adapter._private_collapseSections.append(section)
        adapter.reloadSection(at: section)
    }
    func expand(section:Int){
        if (section >= adapter.sectionCount) || isExpanded(section: section){
            return
        }
        
        adapter._private_collapseSections.remove(item: section)
        adapter.reloadSection(at: section)
    }
    
    func toggleState(section:Int){
        if type == .normal {
            if isExpanded(section: section) {
                collapse(section: section)
                
            } else {
                expand(section: section)
            }
        }
        else {
            if isExpanded(section: section){
                return
            }
            
            collapseAll(except: section)
            expand(section: section)
        }
    }
    
    func collapseAll(except section:Int? = nil){
        adapter.getSections()
            .enumerated()
            .map{$0.offset}
            .filter { $0 != section }
            .forEach { collapse(section: $0) }
    }
    func expandAll(except section:Int? = nil){
        adapter.getSections()
            .enumerated()
            .map{$0.offset}
            .filter { $0 != section }
            .forEach { expand(section: $0) }
    }
    func isCollapsed(section:Int)->Bool{
        return adapter._private_collapseSections.contains(section)
    }
    func isExpanded(section:Int)->Bool{
        return !isCollapsed(section: section)
    }
}

public enum CollapseType {
    case normal
    case accordion
}

