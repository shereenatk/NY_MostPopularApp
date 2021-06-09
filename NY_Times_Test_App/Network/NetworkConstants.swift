//
//  NetworkConstants.swift
//  NY_Times_Test_App
//
//  Created by Development  on 09/06/2021.
//

import Foundation
import Foundation
enum NetworkConstants: Int {
    case code = 200
    case failure = 400
    
    var value: Int {
        return self.rawValue
    }
}

enum NetworkResponseStatus: String {
    case success = "OK"
    
    var value: String {
        return self.rawValue
    }
}
