//
//  MessageingVC.swift
//  ListExample-iOS
//
//  Created by Mostafa Taghipour on 1/19/18.
//  Copyright © 2018 RainyDay. All rights reserved.
//

import UIKit
import RxSwift
import RxKeyboard
import iOSEasyList

class MessagingVC: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet var messageBar: MessageBar!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    var viewModel:MessagingVM!
    var bag=DisposeBag()
    
    lazy var adapter: TableViewAdapter = { [unowned self] in
        let adapter=TableViewAdapter(tableView: tableView)
        
        adapter.configCell = { (tableView, index, data) in
            let message = data as! Message
            
            if message.sender == me {
                let cell = tableView.dequeueReusableCell(withIdentifier: MessageSendCell.reuseIdentifier, for: index) as! MessageSendCell
                cell.data = message
                return cell
            }
            else{
                let cell = tableView.dequeueReusableCell(withIdentifier: MessageReceiveCell.reuseIdentifier, for: index) as! MessageReceiveCell
                cell.data = message
                return cell
            }
        }
        
        adapter.animationConfig = AnimationConfig(reload: .none, insert: .top, delete: .none)
        
        return adapter
        }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.backgroundColor
        self.title="Chat"
        
        messageBar.messageBarDelegate=self
        
        viewModel=MessagingVM()
        
        //config tableview
        tableView.register(UINib(nibName: MessageReceiveCell.className, bundle: nil), forCellReuseIdentifier: MessageReceiveCell.reuseIdentifier)
        tableView.register(UINib(nibName: MessageSendCell.className, bundle: nil), forCellReuseIdentifier: MessageSendCell.reuseIdentifier)
        tableView.allowsSelection=false
        tableView.removeExtraLines()
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 125
        
        tableView.transform = CGAffineTransform(scaleX: 1, y: -1)  //reverse tableview scroll (you also need reverse cells)
        self.tableView.contentInsetAdjustmentBehavior =   .never
        tableView.keyboardDismissMode = .interactive
        updateContentInset()
        
  
        
        //bind tableview
        viewModel
            .items
            .asDriver()
            .drive(onNext: { (items) in
                self.adapter.setData(newData: items)
            })
            .disposed(by: bag)
        
        
        self.view
        .rx.tapGesture()
        .when(.recognized)
        .asObservable()
            .subscribe(onNext: { (gesture) in
                self.view.endEditing(true)
            })
        .disposed(by: bag)
        
        //subscribe keyboard frame changes
        RxKeyboard.instance.visibleHeight
            .drive(onNext: { keyboardVisibleHeight in

                let  safeAreaInset = keyboardVisibleHeight <= self.view.safeAreaInsets.bottom ? 0 : self.view.safeAreaInsets.bottom

                self.bottomConstraint.constant = -keyboardVisibleHeight + safeAreaInset
                
                UIView.animate(withDuration: 0.0) {
                    self.view.layoutIfNeeded()
                }

            })
            .disposed(by: bag)
        
    }
    
    func updateContentInset()  {
        let oldInset =  tableView.contentInset
        let newInset = UIEdgeInsets(top: 16 + messageBar.frame.height , left: 0, bottom: 0, right: 0)
        tableView.contentInset = newInset
        tableView.contentOffset.y = tableView.contentOffset.y + (oldInset.top - newInset.top)
    }
    
}

extension MessagingVC:MessageBarDelegate{
    func messageBar(didSend message: String) {
        messageBar.reset()
        self.viewModel.sendMessage(message: message)
        
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
           self.tableView.scrollToRow(at: IndexPath(row: 0, section: 0) , at: .top, animated: false)
        }
    }
    
    func messageBar(didChange height: CGFloat) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
            self.updateContentInset()
        }
        
    }
}
