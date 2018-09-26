//
//  Filterable.swift
//  AKMaskField
//
//  Created by Remote User on 1/30/18.
//

import Foundation

public protocol Filterable {
    func filterItem (_ constraint: String,_ item: Any)-> Bool
}

public extension Filterable{
    private var adapter:ListAdapter{
        guard let adapter = self as? ListAdapter else {
            fatalError("Filterable must implemment by ListAdapter")
        }
        
        return adapter
    }
    internal func setData(newData:[Any]?){
        if  !adapter._private_lockNoneFilteredItems{
            adapter._private_originalItems=newData
        }
    }
    func setFilterConstraint(constraint: String?){
        adapter._private_lockNoneFilteredItems=true
        
        var list = adapter._private_originalItems
        
        if let query=constraint , !query.isEmpty{
            list = list?.filter{
                filterItem(query,$0)
            }
        }
        
        adapter.setData(newData: list)
        
        adapter._private_lockNoneFilteredItems=false
    }
}
