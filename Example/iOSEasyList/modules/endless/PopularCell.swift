//
//  PopularCell.swift
//  ListExample-iOS
//
//  Created by Mostafa Taghipour on 1/8/18.
//  Copyright © 2018 RainyDay. All rights reserved.
//

import UIKit
import RxSwift
import iOSEasyList

class PopularCell: BaseTableViewCell<PopularMovies> {
    
    @IBOutlet weak var collectionView: UICollectionView!
    let bag=DisposeBag()
    var collectionViewOffset: CGFloat {
        get {
            return collectionView.contentOffset.x
        }
        
        set {
            collectionView.contentOffset.x = newValue
        }
    }
    
    override func initialization() {
        let layout=UICollectionViewSnappingFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 100, height: collectionView.bounds.height)
        layout.minimumLineSpacing = 6
        collectionView.collectionViewLayout  = layout
        collectionView.register(UINib(nibName: PopularMovieCell.className, bundle: nil), forCellWithReuseIdentifier: PopularMovieCell.reuseIdentifier)
        
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.contentInset=UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        collectionView.decelerationRate = UIScrollView.DecelerationRate.fast
    }
    
   override func bind(data:PopularMovies) {
        
        collectionView.dataSource=nil
        collectionView.delegate=nil
        
        Observable
            .just(data.results)
            .bind(to: collectionView.rx.items(cellIdentifier: PopularMovieCell.reuseIdentifier, cellType: PopularMovieCell.self)){
                row, data, cell in

                cell.data = data
            }
            .disposed(by: bag)
    }
    
}
