//
//  MessagingAdapter.swift
//  ListExample-iOS
//
//  Created by Mostafa Taghipour on 1/19/18.
//  Copyright © 2018 RainyDay. All rights reserved.
//

import UIKit
import iOSEasyList

class MessagingAdapter: TableViewAdapter {
    
    override init(tableView: UITableView) {
        super.init(tableView: tableView)
        
        self.configCell = { (tableView, index, data) in
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
        
        animationConfig = AnimationConfig(reload: .none, insert: .top, delete: .none)
        
    }
    
   
}
