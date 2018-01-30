//
//  AnimationAdapter.swift
//  ListExample-iOS
//
//  Created by Mostafa Taghipour on 1/12/18.
//  Copyright © 2018 RainyDay. All rights reserved.
//

import UIKit
import iOSEasyList

class AnimationAdapter : TableViewAdapter {
    
    weak var delegate:AnimationAdapterDelegate?
    
    private var enterAnimationFinished = false
    private var lastVisibleItem : IndexPath?
    

    
     init(tableView:UITableView) {
        super.init(tableView: tableView)
        
        self.configCell = { (tableView, index, data) in
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: index)
            let data = data as! DateModel
            cell.textLabel?.text = data.date.description
            return cell
        }
        
    }
    
     func setData(newData: [Any]) { 
        guard let tableView = tableView else { return  }
        super.setData(newData: newData, animated: !tableView.isEmpty)
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        isAnimationEnable=false
        delegate?.move(item: sourceIndexPath.row, to: destinationIndexPath.row)
        isAnimationEnable=true
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        guard !tableView.isEditing else {
            return []
        }
        
        let delete = UITableViewRowAction(style: .destructive, title: "Delete") { (action, indexPath) in
            self.delegate?.remove(index: indexPath.row)
        }
        
        let edit = UITableViewRowAction(style: .normal, title: "Edit") { (action, indexPath) in
            if let item = self.getItem(indexPath: indexPath) as? DateModel{
                self.delegate?.update(date: item , index: indexPath.row)
            }
        }
        
        edit.backgroundColor = UIColor.blue
        
        return [delete, edit]
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.delegate?.updateMultipleDeleteButtonTitle()
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        self.delegate?.updateMultipleDeleteButtonTitle()
    }
    
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        if self.lastVisibleItem == nil  {
             self.lastVisibleItem=tableView.indexPathsForVisibleRows?.last
        }

        guard let lastVisibleRow = lastVisibleItem?.row , !enterAnimationFinished else { return  }


        if indexPath.row <= lastVisibleRow {

            let delay:TimeInterval = Double(indexPath.row) * 0.05

            cell.alpha = 0.0
            cell.transform = CGAffineTransform(scaleX: 0.5, y: 0.7) //.translatedBy(x: 0, y: 50)

            UIView.animate(withDuration: 0.3, delay: delay, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.8, options: [.curveEaseOut], animations: {
                cell.alpha=1.0
                cell.transform = .identity
            }, completion: nil)

        }

        if indexPath.row >= lastVisibleRow{
            enterAnimationFinished = true
            isAnimationEnable=true
        }
    }
}


protocol AnimationAdapterDelegate:class {
    func move(item from:Int,to:Int)
    func remove(index:Int)
    func update(date: DateModel, index: Int)
    func updateMultipleDeleteButtonTitle()
}





