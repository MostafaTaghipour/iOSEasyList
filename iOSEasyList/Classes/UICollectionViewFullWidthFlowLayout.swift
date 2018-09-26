//
//  FullWidthCellsFlowLayout.swift
//  ListExample-iOS
//
//  Created by Mostafa Taghipour on 1/18/18.
//  Copyright © 2018 RainyDay. All rights reserved.
//

import UIKit

public class UICollectionViewFullWidthFlowLayout : UICollectionViewFlowLayout {
    
    public func fullWidth(forBounds bounds:CGRect) -> CGFloat {
        
        let contentInsets = self.collectionView!.contentInset
        
        return bounds.width - sectionInset.left - sectionInset.right - contentInsets.left - contentInsets.right
    }
    
    // MARK: Overrides
    
    override public func prepare() {
        itemSize.width = fullWidth(forBounds: collectionView!.bounds)
        super.prepare()
    }
    
    override public func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        if !newBounds.size.equalTo(collectionView!.bounds.size) {
            itemSize.width = fullWidth(forBounds: newBounds)
            return true
        }
        return false
    }
}

