//
//  FilteringVM.swift
//  ListExample-iOS
//
//  Created by Mostafa Taghipour on 1/17/18.
//  Copyright © 2018 RainyDay. All rights reserved.
//

import RxSwift

class FilteringVM{
    
    var items=Variable<[Movie]>([])
    
    init() {
        loadTopMovies(page: 0)
    }
    
    func loadTopMovies(page:Int){
        API.getTopRatedMovies(page: page+1, success: { movies in
            self.items.value=movies
        }) { _ in }
    }
    
    func sort(by: SortFactor) {
        var list = items.value
        list.sort(by: { (left, right) -> Bool in
            switch(by){
            case .Title:
                return left.title < right.title
            case .Language:
                return left.original_language < right.original_language
            case .Year:
                return left.release_date < right.release_date
            }
        })
        items.value = list
    }
}


enum SortFactor {
    case  Title
    case Year
    case Language
}
