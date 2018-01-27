//
//  AnimationVM.swift
//  ListExample-iOS
//
//  Created by Mostafa Taghipour on 1/10/18.
//  Copyright © 2018 RainyDay. All rights reserved.
//

import Foundation
import RxSwift
import iOSEasyList

class AnimationVM{

    var items=Variable<[DateModel]>([])
    private var lastDeletedItem:Item?
    
    init() {
        initDates()
    }
    
    func initDates(){
        for i in 1...15{
          let date =  Date() - TimeInterval(i)
            items.value.append(DateModel(Id: i, date: date))
        }
    }
    
   
    func insert(){
        let lastId = items.value.map{$0.Id}.max()
        items.value.insert(DateModel(Id: lastId != nil ? lastId! + 1 : 0 , date: Date()), at: 0)
    }
    
    func update(pos:Int,date:DateModel)  {
        items.value[pos] = date
    }
    
    func remove(pos:Int)  {
lastDeletedItem =  Item(item: items.value.remove(at: pos), index: pos)
    }
    
    func undoLatsRemovedItem(){
        if let item = lastDeletedItem {
            items.value.insert(item.item, at: item.index)
        }
    }
    
    func remove(indexes:[Int])  {
        for index in indexes.sorted(by: >) {
             items.value.remove(at: index)
        }
    }
    
    func move(from:Int,to:Int){
        let element = self.items.value.remove(at: from)
        self.items.value.insert(element, at: to)
    }
    
    private struct Item{
        let item:DateModel
        let index:Int
    }
}

struct DateModel: Diffable {
    func isEqual(to object: Any) -> Bool {
        guard let other = object as? DateModel else {
            return false
        }
        
        return self.Id == other.Id && self.date==other.date
    }
  
    var diffIdentifier: String{
        return String(Id)
    }
    
    let Id:Int
    var date:Date

    
}
