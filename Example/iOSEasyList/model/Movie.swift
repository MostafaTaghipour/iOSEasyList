//
//  Movie.swift
//  ListExample-iOS
//
//  Created by Mostafa Taghipour on 1/5/18.
//  Copyright © 2018 RainyDay. All rights reserved.
//

import Foundation
import iOSEasyList

struct TopRatedMovies:Codable {
    let results:[Movie]
}

class PopularMovies:Codable {
    let results:[Movie]
}

extension PopularMovies:Diffable{
    var diffIdentifier: String {
        
        if let id1 = results.first?.diffIdentifier , let id2 = results.last?.diffIdentifier{
            return id1 + id2
        }
        
        return ""
    }
    
    func isEqual(to object: Any) -> Bool {
        guard let to = object as? PopularMovies else { return false }
        
        return self.results.first==to.results.first && self.results.last == to.results.last
    }
}


struct Movie:Codable{
    let id:Int
    let poster_path: String?
    let overview: String?
    let release_date: String?
    let original_language : String?
    let title: String?
    let backdrop_path: String?
    
    let ratio = Float.random(lower: 0.6, 1.0)
   
}


extension Movie:Equatable{
    static func ==(lhs: Movie, rhs: Movie) -> Bool {
        return lhs.id==rhs.id &&
            lhs.title==rhs.title &&
        lhs.overview==rhs.overview &&
        lhs.release_date==rhs.release_date &&
        lhs.original_language==rhs.original_language &&
        lhs.backdrop_path==rhs.backdrop_path &&
        lhs.poster_path==rhs.poster_path
    }
}


extension Movie:Diffable{
    var diffIdentifier: String {
        return "\(id)-\(title)"
    }

    func isEqual(to object: Any) -> Bool {
        guard let to = object as? Movie else { return false }

        return self==to
    }
}







