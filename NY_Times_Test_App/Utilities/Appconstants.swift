//
//  Appconstants.swift
//  NY_Times_Test_App
//
//  Created by Development  on 09/06/2021.
//

import Foundation
class AppConstants {
    
    static let apiKey = "DGPl4MdyyVYPGGgX1vMA95A9A3FGGXRG"
    
    struct BaseURL {
        static let url = "https://api.nytimes.com/svc/mostpopular/v2/"
    }
    
    class func getBaseUrl() -> String {
        return BaseURL.url
    }
    
    class func getApiHeaders() -> [String: String] {
            return [
                    "accept": "application/json",
                "Content-Type": "application/json"
                ]
    }
}
