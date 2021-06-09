//
//  AppColor.swift
//  NY_Times_Test_App
//
//  Created by Development  on 09/06/2021.
//

import UIKit
import Foundation

enum AppColor {
    case primaryColor
    case backgoundWhite
}

extension AppColor {
    var value: UIColor {
        var instanceColor = UIColor.clear
        switch self {
        case .primaryColor:
            instanceColor = UIColor(red: 0.31, green: 0.89, blue: 0.77, alpha: 1.00)
             
         case .backgoundWhite:
            instanceColor = UIColor(red: 0.98, green: 0.98, blue: 0.98, alpha: 1.00)
            
        }
        return instanceColor
    }
    
    var cgColor: CGColor {
        return self.value.cgColor
    }
}
  
