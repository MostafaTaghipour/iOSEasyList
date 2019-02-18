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
    
    let contantPadding :CGFloat = 12
    let itemSpacing :CGFloat = 12
    
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
    
    
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(deviceRotated), name: UIDevice.orientationDidChangeNotification, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self, name: UIDevice.orientationDidChangeNotification, object: nil)
    }
    
    @objc func deviceRotated(){
        if UIDevice.current.orientation.isLandscape {
            //Code here
        } else {
            //Code here
        }
        setLayout(type: adapter.layoutType, force: true)
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
             layout.minimumLineSpacing=itemSpacing
            layout.sectionInset = UIEdgeInsets(top: contantPadding, left: contantPadding, bottom: contantPadding, right: contantPadding)
            collectionView.collectionViewLayout = layout
            break
        case .Grid:
            let layout = UICollectionViewFlowLayout()
            layout.minimumInteritemSpacing=itemSpacing/2
            layout.minimumLineSpacing=itemSpacing
            layout.sectionInset = UIEdgeInsets(top: contantPadding, left: contantPadding, bottom: contantPadding, right: contantPadding)
            collectionView.collectionViewLayout = layout
            break
        case .Spanned:
            let layout = UICollectionViewFlowLayout()
            layout.minimumInteritemSpacing=itemSpacing/2
            layout.minimumLineSpacing=itemSpacing
            layout.sectionInset = UIEdgeInsets(top: contantPadding, left: contantPadding, bottom: contantPadding, right: contantPadding)
            collectionView.collectionViewLayout = layout
            break
        case .Staggered:
            let layout = UICollectionViewStaggeredLayout()
            layout.columnCount = UIDevice.current.orientation == UIDeviceOrientation.portrait ? 2 : 3
         layout.minimumColumnSpacing=itemSpacing
            layout.sectionInset = UIEdgeInsets(top:contantPadding, left: contantPadding, bottom: contantPadding, right:contantPadding)
            collectionView.collectionViewLayout = layout
        
            break
        case .Flow:
            let layout = UICollectionViewJustifiedFlowLayout()
            layout.horizontalAlignment = .left
            layout.estimatedItemSize = CGSize(width: 1, height: 1)
            layout.minimumInteritemSpacing=itemSpacing
            layout.minimumLineSpacing=itemSpacing
            layout.sectionInset = UIEdgeInsets(top: contantPadding, left: contantPadding, bottom: contantPadding, right: contantPadding)
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
