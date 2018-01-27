//
//  EndlessVM.swift
//  ListExample-iOS
//
//  Created by Mostafa Taghipour on 1/5/18.
//  Copyright © 2018 RainyDay. All rights reserved.
//

import RxSwift
import iOSEasyList

class ExpandableVM{
    
    var items=Variable<[MovieExpandableSection]>([])
    private var collapseByDefault:Bool!
    private var accordion:Bool!
    
    init(collapseByDefault:Bool=true,accordion:Bool=false) {
        loadTopMovies(page: 1)
        self.collapseByDefault = collapseByDefault
        self.accordion=accordion
    }
    
    func loadTopMovies(page:Int){
        
        API.getTopRatedMovies(page: page, success: { movies in
            
            
            var i = 0
            let newItems : [MovieExpandableSection] = movies.grouped(by: { (movie) in
                return String(movie.release_date[...3])
            })
                .sorted{
                    $0.key > $1.key
                }
                .map{ (header,items) in
                var collapsed = self.collapseByDefault
                
                if self.accordion {
                    collapsed = i != 0
                }
                
                i+=1
                return MovieExpandableSection(header: header, items: items, collapsed: collapsed!)
            }
            

            self.items.value = newItems
            
        }) { error in }
        
    }
    
    func toggleSection(position:Int){
        if accordion {
            guard self.items.value[position].collapsed else {return}
            
            for (index,item) in items.value.enumerated() {
                if !item.collapsed {
                    self.items.value[index].collapsed=true
                }
            }
            
            self.items.value[position].collapsed = false
        }
        else{
            self.items.value[position].collapsed = !self.items.value[position].collapsed
        }
    }
}


struct MovieExpandableSection:Diffable {
    var header : String
    var items : [Movie]
    var collapsed : Bool
}

extension MovieExpandableSection:SectionDiffable{
    var sectionItems: Array<Diffable> {
        return items
    }
    
    var diffIdentifier: String {
        return header
    }
    
    func isEqual(to object: Any) -> Bool {
        guard let to = object as? MovieExpandableSection else{
            return false
        }
        
        return self.header == to.header &&
            self.collapsed == to.collapsed
    }
}

