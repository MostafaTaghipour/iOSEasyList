//
//  BaseCell.swift
//  ListExample-iOS
//
//  Created by Mostafa Taghipour on 1/12/18.
//  Copyright © 2018 RainyDay. All rights reserved.
//

import UIKit

public protocol ReusableView {
    static var reuseIdentifier: String { get }
}

public extension ReusableView {
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}


open class BaseTableViewCell<T>:UITableViewCell,ReusableView {
    public var data:T?{
        didSet{
            guard let data = data else { return  }
            bind(data: data)
        }
    }
    
    override open func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        initialization()
    }
    
    open func initialization(){}
    
    open  func bind(data:T){}
}

open class BaseCollectionViewCell<T>:UICollectionViewCell,ReusableView {
    public var data:T?{
        didSet{
            guard let data = data else { return  }
            bind(data: data)
        }
    }
    
    override open func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        initialization()
    }
    
    open func initialization(){}
    open func bind(data:T){}
}

