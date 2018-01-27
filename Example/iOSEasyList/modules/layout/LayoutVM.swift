//
//  LayoutVM.swift
//  ListExample-iOS
//
//  Created by Mostafa Taghipour on 1/17/18.
//  Copyright © 2018 RainyDay. All rights reserved.
//

import RxSwift

class LayoutVM{
    
    var items=Variable<[Movie]>([])
    
    init() {
        loadTopMovies(page: 0)
    }
    
    func loadTopMovies(page:Int){
        API.getTopRatedMovies(page: page+1, success: { movies in
            self.items.value.append(contentsOf: movies)
        }) { _ in }
    }
}
