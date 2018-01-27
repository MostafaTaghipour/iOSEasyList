//
//  AnimationVC.swift
//  ListExample-iOS
//
//  Created by Mostafa Taghipour on 1/10/18.
//  Copyright © 2018 RainyDay. All rights reserved.
//

import UIKit
import RxSwift
import iOSEasyList

class AnimationVC: UIViewController {
    
    var viewModel:AnimationVM!
    var adapter:AnimationAdapter!
    var bag=DisposeBag()
    var deleteMultipleItemButton:UIBarButtonItem?
    
    var selectedDate:Date?
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.backgroundColor
        self.title="Animation"
        self.navigationController?.navigationBar.prefersLargeTitles=true
        self.navigationItem.rightBarButtonItems = [UIBarButtonItem(title: "Add", style: .plain, target: self, action: #selector(self.new)),self.editButtonItem]
        
        viewModel=AnimationVM()
        
        adapter=AnimationAdapter(tableView: tableView)
        adapter.delegate=self
        adapter.animationConfig = AnimationConfig(reload: .fade, insert: .left, delete: .left)
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.allowsSelection=false
        tableView.allowsMultipleSelectionDuringEditing=true
        tableView.removeExtraLines()
        
        
        viewModel
            .items
            .asDriver()
            .drive(onNext: { (dates) in
                self.adapter.setData(newData: dates)
            })
            .disposed(by: bag)
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        
        tableView.setEditing(editing, animated: animated)
        
        self.deleteMultipleItemButton = editing ? UIBarButtonItem(title: "", style: .plain, target: self, action: #selector(self.deleteMultiple)) : nil
        
        self.navigationItem.leftBarButtonItems = editing ? [deleteMultipleItemButton!] : []
    }
    
    @objc func new(){
        viewModel.insert()
    }
    
    @objc func deleteMultiple(){
        if let rows = tableView.indexPathsForSelectedRows?.map({ (indexPath) -> Int in indexPath.row }){
            viewModel.remove(indexes: rows)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                self.updateMultipleDeleteButtonTitle()
            })
        }
    }
    
    override func motionEnded(_ motion: UIEventSubtype, with event: UIEvent?) {
        if motion == .motionShake {
            viewModel.undoLatsRemovedItem()
        }
    }
}

extension AnimationVC:AnimationAdapterDelegate{
    func move(item from: Int, to: Int) {
        viewModel.move(from: from, to: to)
    }
    
    func remove(index: Int) {
        viewModel.remove(pos: index)
        updateMultipleDeleteButtonTitle()
    }
    
    func update(date: DateModel, index: Int) {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        
                let alert = UIAlertController(title: "Some Title", message: "Enter a text", preferredStyle: .alert)
                alert.addTextField { (textField) in
                    textField.text = dateFormatter.string(from: date.date)
                }
        
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
                    guard let dateStr = alert?.textFields?[0].text else { // Force unwrapping because we know it exists.
                        return
                    }
        
                    if let dt = dateFormatter.date(from: dateStr){
        
                        var updatedDate=date
                        updatedDate.date=dt
        
                        self.viewModel.update(pos: index, date: updatedDate)
                    }
                }))
        
                self.present(alert, animated: true, completion: nil)
    }
    
    func updateMultipleDeleteButtonTitle() {
         self.deleteMultipleItemButton?.title = tableView.selectedRowCount > 0 ? "Delete \(tableView.selectedRowCount) item" : ""
    }
}
