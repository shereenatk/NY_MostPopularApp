//
//  PageRouter.swift
//  NY_Times_Test_App
//
//  Created by Development  on 09/06/2021.
//

import Foundation
import Alamofire

enum PageRouter: URLRequestConvertible {
   
    case getArticleList([String: Any])
    
    var method: HTTPMethod {
        switch self {
        case
            .getArticleList:
            return .get
        }
    }
    
    func asURLRequest() throws -> URLRequest {
        let encoding: ParameterEncoding = {
            switch self {
            case
               .getArticleList:
                return URLEncoding.default
            }
        }()
        let params: ([String: Any]?) = {
           switch self {
           case
            .getArticleList(let params):
               return params
           }
        }()
               
        
        let headers: HTTPHeaders = {
            switch self {
            case
                 .getArticleList:
                return AppConstants.getApiHeaders()
            }
        }()
        
        let url: URL? = {
            let relativePath: String?
            switch self {
            case .getArticleList:
                relativePath = "viewed/30.json"
            }
            
            var url = URL(string: AppConstants.getBaseUrl())
            
            if let relativePath = relativePath {
                url = url?.appendingPathComponent(relativePath)
            }
            return url
        }()
        
        guard let formedURL = url else {
            throw URLError.urlMalformatted
        }
        var urlRequest = URLRequest(url: formedURL)
        urlRequest.httpMethod = method.rawValue
        urlRequest.allHTTPHeaderFields = headers
        
        return try encoding.encode(urlRequest, with: params)
    }
}



