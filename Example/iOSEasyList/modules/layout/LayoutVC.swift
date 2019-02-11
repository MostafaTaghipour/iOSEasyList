//
//  LayoutVC.swift
//  ListExample-iOS
//
//  Created by Mostafa Taghipour on 1/17/18.
//  Copyright © 2018 RainyDay. All rights reserved.
//

import UIKit
import RxSwift
import RxGesture
import iOSEasyList

class LayoutVC: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    var adapter:LayoutAdapter!
    
    var viewModel:LayoutVM!
    var bag=DisposeBag()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.backgroundColor
        self.title="Layout"
        self.navigationController?.navigationBar.prefersLargeTitles=true
        self.navigationItem.rightBarButtonItem=UIBarButtonItem(title: "Change Layout", style: .plain, target: self, action: #selector(self.changeLayout))
        
        
        viewModel=LayoutVM()
        
        //config colectionView
        collectionView.register(UINib(nibName: ListCell.className, bundle: nil), forCellWithReuseIdentifier: ListCell.reuseIdentifier)
        collectionView.register(UINib(nibName: GridCell.className, bundle: nil), forCellWithReuseIdentifier: GridCell.reuseIdentifier)
        collectionView.register(UINib(nibName: StaggeredCell.className, bundle: nil), forCellWithReuseIdentifier: StaggeredCell.reuseIdentifier)
         collectionView.register(UINib(nibName: FlowCell.className, bundle: nil), forCellWithReuseIdentifier: FlowCell.reuseIdentifier)
        collectionView.allowsSelection=false
        collectionView.backgroundColor = .clear
        
        //setup adapter
        adapter=LayoutAdapter(collectionView: collectionView)
        
        //set layout
        setLayout(type: .Linear,force: true)
        
        //bind tableview
        viewModel
            .items
            .asDriver()
            .drive(onNext: { [weak self] (items) in
                self?.adapter.setData(newData: items)
            })
            .disposed(by: bag)
    }
    
    @objc func changeLayout(){
        let layoutMenu = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let LinearAction = UIAlertAction(title: "Linear", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            self.setLayout(type: .Linear)
        })
        let GridAction = UIAlertAction(title: "Grid", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            self.setLayout(type: .Grid)
        })
        let SpannedAction = UIAlertAction(title: "Spanned", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
             self.setLayout(type: .Spanned)
        })
        let StaggeredAction = UIAlertAction(title: "Staggered", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
             self.setLayout(type: .Staggered)
        })
        let FlowAction = UIAlertAction(title: "Flow", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            self.setLayout(type: .Flow)
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        
        layoutMenu.addAction(LinearAction)
        layoutMenu.addAction(GridAction)
        layoutMenu.addAction(SpannedAction)
        layoutMenu.addAction(StaggeredAction)
        layoutMenu.addAction(FlowAction)
        layoutMenu.addAction(cancelAction)
        
        self.present(layoutMenu, animated: true, completion: nil)
    }
    
    func setLayout(type:LayoutType,force:Bool=false){
        
        guard force || adapter.layoutType != type else{
            return
        }
        
        adapter.layoutType = type
        
        switch type {
        case .Linear:
            let layout = UICollectionViewFullWidthFlowLayout()
            collectionView.collectionViewLayout = layout
            break
        case .Grid:
            let layout = UICollectionViewFlowLayout()
            layout.minimumInteritemSpacing=5
            layout.minimumLineSpacing=5
            layout.sectionInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
            collectionView.collectionViewLayout = layout
            break
        case .Spanned:
            let layout = UICollectionViewFlowLayout()
            layout.minimumInteritemSpacing=5
            layout.minimumLineSpacing=5
            layout.sectionInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
            collectionView.collectionViewLayout = layout
            break
        case .Staggered:
            let layout = UICollectionViewStaggeredLayout()
            layout.columnCount = 3
         layout.minimumColumnSpacing=5
            collectionView.collectionViewLayout = layout
        
            break
        case .Flow:
            let layout = UICollectionViewJustifiedFlowLayout()
            layout.horizontalAlignment = .left
            layout.estimatedItemSize = CGSize(width: 1, height: 1)
            layout.minimumInteritemSpacing=8
            layout.minimumLineSpacing=8
            layout.sectionInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
            collectionView.collectionViewLayout = layout
        }
        
        collectionView.reloadData()
    }
    
}

enum  LayoutType:Int {
    case Linear = 1
    case Grid = 2
    case Spanned = 3
    case Staggered = 4
    case Flow = 5
}
