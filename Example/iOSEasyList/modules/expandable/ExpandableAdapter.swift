//
//  Expandable.swift
//  ListExample-iOS
//
//  Created by Mostafa Taghipour on 1/13/18.
//  Copyright © 2018 RainyDay. All rights reserved.
//

import UIKit
import iOSEasyList

class ExpandableAdapter: TableViewAdapter {
    private let HEADER_HEIGHT:CGFloat=44
    weak var delegate:ExpandableAdapterDelegate?
    
    override init(tableView: UITableView) {
        super.init(tableView: tableView)
        
        self.configCell = { (tableView, index, data) in
            let cell = tableView.dequeueReusableCell(withIdentifier: MovieCell.reuseIdentifier, for: index) as! MovieCell
            let data = data as! Movie
            cell.data=data
            return cell
        }
        
    }
    
    func setData(newData: [Any]) {
        guard let tableView = tableView else { return  }
        super.setData(newData: newData, animated: !tableView.isEmpty)
    }
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: CollapsibleTableViewHeader.reuseIdentifier) as! CollapsibleTableViewHeader
        
        headerView.data=getSection(section: section, itemType: MovieExpandableSection.self)
        headerView.section=section
        headerView.delegate = self
        return headerView
    }
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return HEADER_HEIGHT
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let section = getSection(section: section, itemType: MovieExpandableSection.self)
            else { return 0 }
        
        return  section.collapsed ? 0 : section.sectionItems.count
    }
    
    
    // disable sticky header trick
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let sectionHeaderHeight: CGFloat = HEADER_HEIGHT
        if scrollView.contentOffset.y <= sectionHeaderHeight && scrollView.contentOffset.y >= 0 {
            scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0)
        }
        else if scrollView.contentOffset.y >= sectionHeaderHeight {
            scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0)
        }
        
    }
}

extension ExpandableAdapter:CollapsibleTableViewHeaderDelegate{
    func toggleSection(_ header: CollapsibleTableViewHeader, section: Int) {
        self.delegate?.toggleSection(position: section)
    }
}


protocol ExpandableAdapterDelegate:class {
   func toggleSection(position: Int)
}
