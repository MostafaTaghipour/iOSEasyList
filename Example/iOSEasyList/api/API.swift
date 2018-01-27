//
//  API.swift
//  ListExample-iOS
//
//  Created by Mostafa Taghipour on 1/5/18.
//  Copyright © 2018 RainyDay. All rights reserved.
//

import Moya

class API {
    static let baseUrl="https://api.themoviedb.org/3/movie/"
    static let baseImageUrl = "https://image.tmdb.org/t/p/"
    static let apiKey="ec01f8c2eb6ac402f2ca026dc2d9b8fd"
    static private let provider=MoyaProvider<MovieApi>()
    
    static func getTopRatedMovies(page:Int,success:@escaping ([Movie])->(),failure:@escaping (Error)->()){
       
        if !Connectivity.isConnectedToInternet {
            failure(InternetConnectionError())
            return
        }
        
        provider.request(.topRated(page: page)) { (result) in
            switch result{
            case let .success(response):
                do{
                    let results=try JSONDecoder().decode(TopRatedMovies.self, from: response.data)
                    success(results.results)
                }
                catch let err{
                    failure(err)
                }
                
            case let .failure(error):
                failure(error)
            }
        }
    }
    
    static func getPopularMovies(page:Int,success:@escaping (PopularMovies)->(),failure:@escaping (Error)->()){
        provider.request(.popular(page: page)) { (result) in
            switch result{
            case let .success(response):
                do{
                    let results=try JSONDecoder().decode(PopularMovies.self, from: response.data)
                    success(results)
                }
                catch let err{
                    failure(err)
                }
                
            case let .failure(error):
                failure(error)
            }
        }
    }
}
