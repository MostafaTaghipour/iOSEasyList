//
//  MessagingVM.swift
//  ListExample-iOS
//
//  Created by Mostafa Taghipour on 1/19/18.
//  Copyright © 2018 RainyDay. All rights reserved.
//

import Foundation
import RxSwift

class MessagingVM  {
    
    let items = Variable<[Message]>([])
    
    init() {
        loadMessages()
    }
    
    private func loadMessages() {
        var list = [Message]()
        list.append( Message(message: "can you borrow me your book, i really need it \ni promise you give back it very soon.", sender: sarah, createdAt: Date().millisecondsSince1970))
        list.append( Message(message: "hi sarah \ni'm fine", sender: me, createdAt: Date().millisecondsSince1970-200000))
        list.append( Message(message: "hi john how are you ?", sender: sarah, createdAt: Date().millisecondsSince1970-300000))
        items.value=list
    }
    
    func sendMessage(message: String) {
        items.value.insert(Message(message: message, sender: me, createdAt: Date().millisecondsSince1970), at: 0)
    }
    
    
}
