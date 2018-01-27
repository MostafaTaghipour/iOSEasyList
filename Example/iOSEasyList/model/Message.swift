//
//  Message.swift
//  ListExample-iOS
//
//  Created by Mostafa Taghipour on 1/19/18.
//  Copyright © 2018 RainyDay. All rights reserved.
//

import UIKit
import iOSEasyList

struct Message{
    let message: String
    let sender: User
    let createdAt: Int64
}
extension Message:Equatable{
    static func ==(lhs: Message, rhs: Message) -> Bool {
        return lhs.message==rhs.message &&
        lhs.sender==rhs.sender &&
        lhs.createdAt == rhs.createdAt
    }
}

extension Message:Diffable{
    var diffIdentifier: String {
        return "\(message) - \(createdAt))"
    }
    
    func isEqual(to object: Any) -> Bool {
        guard let to = object as? Message else { return false }
        return self == to
    }
}

struct User{
    let nickname: String
    let avatar: UIImage?
}
extension User:Equatable{
    static func ==(lhs: User, rhs: User) -> Bool {
        return lhs.nickname==rhs.nickname
    }
}


var me: User = User(nickname: "me", avatar: nil)
var sarah: User = User(nickname: "sarah", avatar: #imageLiteral(resourceName: "sarah.jpeg"))
