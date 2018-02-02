//
//  SectionedAdapter.swift
//  ListExample-iOS
//
//  Created by Mostafa Taghipour on 1/12/18.
//  Copyright © 2018 RainyDay. All rights reserved.
//

import UIKit
import iOSEasyList

class SectionedAdapter: TableViewAdapter {

     init(tableView: UITableView) {
        super.init(tableView: tableView)
        
        self.configCell = { (tableView, index, data) in
            let cell = tableView.dequeueReusableCell(withIdentifier: MovieCell.reuseIdentifier, for: index) as! MovieCell
            let data = data as! Movie
            cell.data=data
            return cell
        }
        
        isAnimationEnable=false
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard let char = getSection(section: section, itemType: MovieSection.self)?.firstLetter else { return "" }
        return String(char)
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: SectionFooter.reuseIdentifier) as! SectionFooter

        footerView.data=getSection(section: section, itemType: MovieSection.self)
        
        return footerView
    }
    
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 34
    }
    
    
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return getSections(itemType: MovieSection.self)?.map {$0.firstLetter}
    }
    
    func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
        return getSections(itemType: MovieSection.self)?.map {$0.firstLetter}.index(of: title) ?? 0
    }
}
