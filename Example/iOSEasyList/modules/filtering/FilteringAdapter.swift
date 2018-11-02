//
//  FilteringAdapter.swift
//  iOSEasyList_Example
//
//  Created by Mostafa Taghipour on 1/30/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import UIKit
import iOSEasyList

class FilteringAdapter: TableViewAdapter,Filterable {
    
    func filterItem(_ constraint: String, _ item: Any) -> Bool {
        return (item as? Movie)?.title?.lowercased().contains(constraint.lowercased()) ?? false
    }
    
    init(tableView:UITableView) {
        super.init(tableView: tableView)
        
        configCell = { (tv, ip, item) -> (UITableViewCell) in
            let cell = tv.dequeueReusableCell(withIdentifier: MovieCell.reuseIdentifier, for: ip) as! MovieCell
            cell.data = item as? Movie
            return cell
            
        }
        
        setEmptyView(emptyView: EmptyView(frame: .zero))
    }
}
