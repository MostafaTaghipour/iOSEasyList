//
//  Api.swift
//  ListExample-iOS
//
//  Created by Mostafa Taghipour on 1/5/18.
//  Copyright © 2018 RainyDay. All rights reserved.
//

import Moya

enum MovieApi {
    case topRated(page:Int)
    case popular(page:Int)
}

extension MovieApi: TargetType {

    var baseURL: URL {
        guard let url = URL(string: API.baseUrl) else { fatalError("baseURL could not be configured") }
        return url
    }
    
    var path: String {
        switch self {
        case .topRated:
            return "top_rated"
        case .popular:
            return "popular"
        }
    }
    
    var task: Task {
        switch self {
        case .topRated(let page) , .popular(let page):
            return .requestParameters(parameters: ["api_key":API.apiKey,
                                                   "language":"en_US",
                                                   "page":page],
                                      encoding: URLEncoding.queryString)
        }
    }
    
    var method: Moya.Method {
            return .get
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var headers: [String : String]? {
        return nil
    }
    
}



