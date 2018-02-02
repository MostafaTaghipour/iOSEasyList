//
//  LayoutAdapter.swift
//  ListExample-iOS
//
//  Created by Mostafa Taghipour on 1/18/18.
//  Copyright © 2018 RainyDay. All rights reserved.
//

import UIKit
import iOSEasyList

class LayoutAdapter: CollectionViewAdapter {
    
    var layoutType:LayoutType = .Linear
    
     init(collectionView: UICollectionView) {
        super.init(collectionView: collectionView)
        
        configCell={(cv, ip, item) -> (UICollectionViewCell) in
            
            switch self.layoutType {
            case .Linear:
                let cell = cv.dequeueReusableCell(withReuseIdentifier: ListCell.reuseIdentifier, for: ip) as! ListCell
                cell.data = item as? Movie
                return cell
            case .Grid :
                let cell = cv.dequeueReusableCell(withReuseIdentifier: GridCell.reuseIdentifier, for: ip) as! GridCell
                cell.data = item as? Movie
                return cell
            case  .Spanned:
                let cell = cv.dequeueReusableCell(withReuseIdentifier: GridCell.reuseIdentifier, for: ip) as! GridCell
                cell.data = item as? Movie
                cell.titleLabel.font =  cell.titleLabel.font.withSize(ip.row < 4 ? 16 : 11)
                return cell
            case  .Staggered:
                let cell = cv.dequeueReusableCell(withReuseIdentifier: StaggeredCell.reuseIdentifier, for: ip) as! StaggeredCell
                cell.data = item as? Movie
                return cell
            case .Flow:
                let cell = cv.dequeueReusableCell(withReuseIdentifier: FlowCell.reuseIdentifier, for: ip) as! FlowCell
                cell.data = item as? Movie
                return cell
            }
        }
    }
 
}

extension LayoutAdapter:UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch layoutType {
        case .Linear:
            let fullWidthLayout=collectionViewLayout as! UICollectionViewFullWidthFlowLayout
            return CGSize(width: fullWidthLayout.fullWidth(forBounds: collectionView.bounds), height:120)
        case .Grid:
            let numberOfCell:CGFloat = 2
            let layout=collectionViewLayout as! UICollectionViewFlowLayout
            let contextWidth = collectionView.bounds.width - (layout.sectionInset.left + layout.sectionInset.right)
            let width = (contextWidth / numberOfCell) - layout.minimumInteritemSpacing
            return CGSize(width: width, height: 300)
        case .Spanned:
            let numberOfCell:CGFloat = indexPath.row<4 ? 2 : 4
            let layout=collectionViewLayout as! UICollectionViewFlowLayout
            let contextWidth = collectionView.bounds.width - (layout.sectionInset.left + layout.sectionInset.right)
            let width = (contextWidth / numberOfCell) - layout.minimumInteritemSpacing
            let height:CGFloat = indexPath.row<4 ? 250 : 150
            return CGSize(width: width, height: height)
        default:
            return CGSize.zero
            
        }
    }
}

extension LayoutAdapter:UICollectionViewDelegateStaggeredLayout{
    func collectionView(_ collectionView: UICollectionView, layout staggeredCollectionViewLayout: UICollectionViewStaggeredLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
                      let width = staggeredCollectionViewLayout.itemWidthInSectionAtIndex(indexPath.section)
                      let data = getItem(indexPath: indexPath, itemType: Movie.self)!
                      let height = width / CGFloat(data.ratio)
        
                      return CGSize(width: width, height: height)
    }
}




