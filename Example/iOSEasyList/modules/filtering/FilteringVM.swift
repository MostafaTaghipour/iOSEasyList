//
//  FilteringVM.swift
//  ListExample-iOS
//
//  Created by Mostafa Taghipour on 1/17/18.
//  Copyright © 2018 RainyDay. All rights reserved.
//

import RxSwift

class FilteringVM{
    
    private var originalItems = [Movie]()
    private var query: String? = nil
    private var sortFactor: SortFactor? = nil
    
    var items=Variable<[Movie]>([])
    
    init() {
        loadTopMovies(page: 0)
    }
    
    func loadTopMovies(page:Int){
        API.getTopRatedMovies(page: page+1, success: { movies in
          self.originalItems = movies
            self.updateItems()
        }) { _ in }
    }
    
    
    private func updateItems() {
        var list  = originalItems
        
        
        if let query = query , !query.isEmpty{
            list = list.filter { $0.title.lowercased().contains(query.lowercased()) }
        }
        
        if let sortFactor = sortFactor{
            
         list.sort(by: { (left, right) -> Bool in
                switch(sortFactor){
                case .Title:
                    return left.title < right.title
                case .Language:
                    return left.original_language < right.original_language
                case .Year:
                    return left.release_date < right.release_date
                }
            })
        }
        
        
        items.value = list
    }
    
    func setFilter(newText: String?) {
        query = newText
        updateItems()
    }
    
    func sort(by: SortFactor) {
        sortFactor = by
        updateItems()
    }
    
}


enum SortFactor {
    case  Title
    case Year
    case Language
}
