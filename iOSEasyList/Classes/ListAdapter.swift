//
//  BaseAdapter.swift
//  AKMaskField
//
//  Created by Remote User on 1/30/18.
//

import UIKit

open class ListAdapter : NSObject{
    
    // variables
    var _private_noneFilteredItems:[Any]?
    var _private_lockNoneFilteredItems=false
    public var isAnimationEnable:Bool=true
    var emptyView:UIView?
    
    // setters
    public func setData(newData:[Any]?,animated:Bool=true){
        if self is Filterable && !_private_lockNoneFilteredItems{
            _private_noneFilteredItems=newData
        }
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
    public func getData()->[Any]{
        return []
    }
    
    public func getData<T>(itemType: T.Type)->[T]?{
        return nil
    }
    
    public func getItem(indexPath:IndexPath)->Any?{
        return  nil
    }
    
    public func getItem<T>(indexPath:IndexPath, itemType: T.Type)->T?{
        return nil
    }
    
    public func getSection(section:Int)->Any?{
        return nil
    }
    
    public func getSection<T>(section:Int, itemType: T.Type)->T?{
        return nil
    }
}
