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

            let newItems : [MovieExpandableSection] = movies.grouped(by: { (movie) in
                return String(movie.release_date[...3])
            })
                .sorted{
                    $0.key > $1.key
                }
                .map{ (header,items) in
                return MovieExpandableSection(header: header, movies: items)
            }
            

            self.items.value = newItems
            
        }) { error in }
        
    }
    
}


struct MovieExpandableSection {
    var header : String
    var movies : [Movie]
}


extension MovieExpandableSection:SectionDiffable{
    var diffableItems: Array<Diffable> {
        return movies
    }

    var diffIdentifier: String {
        return header
    }

    func isEqual(to object: Any) -> Bool {
        guard let to = object as? MovieExpandableSection else{
            return false
        }

        return self.header == to.header
    }
}

