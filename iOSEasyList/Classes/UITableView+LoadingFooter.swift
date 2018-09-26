//
//  UITableView+LoadingFooter.swift
//  ListExample-iOS
//
//  Created by Mostafa Taghipour on 1/10/18.
//  Copyright © 2018 RainyDay. All rights reserved.
//

import UIKit

//MARK:- LoadingFooter
fileprivate struct AssociatedKeys {
    static var loadingFooterView:UIView?
    static var retryFooterView:UIView?
    static var loadingFooter:Bool = false
    static var retryFooter:Bool = false
}

extension UITableView {
    
    public var loadingFooterView:UIView?{
        get{
            guard let value = objc_getAssociatedObject(self, &AssociatedKeys.loadingFooterView) as? UIView else {
                return nil
            }
            return value
        }
        set(newValue){
            objc_setAssociatedObject(self, &AssociatedKeys.loadingFooterView, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    public  var retryFooterView:UIView?{
        get{
            guard let value = objc_getAssociatedObject(self, &AssociatedKeys.retryFooterView) as? UIView else {
                return nil
            }
            return value
        }
        set(newValue){
            objc_setAssociatedObject(self, &AssociatedKeys.retryFooterView, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    public  var loadingFooter:Bool{
        
        get{
            guard let value = objc_getAssociatedObject(self, &AssociatedKeys.loadingFooter) as? Bool else {
                return false
            }
            return value
        }
        
        set(newValue){
            objc_setAssociatedObject(self, &AssociatedKeys.loadingFooter, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            
            
            if newValue{
                retryFooter=false
            }
            
            if newValue && tableFooterView != loadingFooterView{
                tableFooterView=loadingFooterView
            }
            else if !newValue && tableFooterView == loadingFooterView{
                let point: CGPoint = contentOffset
                tableFooterView=UIView()
                contentOffset = point
            }
        }
        
    }
    
    public  var retryFooter:Bool{
        
        get{
            guard let value = objc_getAssociatedObject(self, &AssociatedKeys.retryFooter) as? Bool else {
                return false
            }
            return value
        }
        
        set(newValue){
            objc_setAssociatedObject(self, &AssociatedKeys.retryFooter, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            
            
            if newValue{
                loadingFooter=false
            }
            
            if newValue && tableFooterView != retryFooterView{
                tableFooterView=retryFooterView
            }
            else if !newValue && tableFooterView == retryFooterView{
                let point: CGPoint = contentOffset
                tableFooterView=UIView()
                contentOffset = point
            }
        }
        
    }
}


