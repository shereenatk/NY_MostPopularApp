//
//  URLERROR.swift
//  NY_Times_Test_App
//
//  Created by Development  on 09/06/2021.
//

import Foundation
fileprivate extension String {
    static let invalidURL = "URL is not valid"
}
enum URLError: Error {
    
    case urlMalformatted
    var value: String {
        switch self {
        case .urlMalformatted:
            return .invalidURL
        }
    }
}
