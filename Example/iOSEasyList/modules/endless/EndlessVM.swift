//
//  EndlessVM.swift
//  ListExample-iOS
//
//  Created by Mostafa Taghipour on 1/5/18.
//  Copyright © 2018 RainyDay. All rights reserved.
//

import RxSwift

class EndlessVM{
    var items=Variable<[Any]>([])
    var loading=Variable<Bool>(false)
    var error=Variable<String?>(nil)
    private var popularLoading: Bool = false
    
    init() {
        loadTopMovies(page: 0)
    }
    
    func loadTopMovies(page:Int,clearOld:Bool=false){
        error.value=nil
        loading.value=true
        
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) {
            
            
            API.getTopRatedMovies(page: page+1, success: { movies in
                
                self.loading.value = false
                
                if clearOld{
                    self.items.value.removeAll()
                }
                
                self.items.value.append(contentsOf: movies as [Any])
                
                self.loadPopularMovies(page: page)
                
            }) { error in
                self.loading.value=false
                self.error.value = "Some thing wrong"
            }
            
        }
    }
    
    
    func loadPopularMovies(page: Int) {
        
        if popularLoading{
            return
        }
        
        popularLoading = true
        
        API.getPopularMovies(page:  page+1, success: { populars in
            
            self.popularLoading=false
            
            
            self.items.value.append(populars)
            
        }) { error in
            self.popularLoading=false
        }
    }
    
}
