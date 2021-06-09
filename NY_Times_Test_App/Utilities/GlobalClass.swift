//
//  GlobalClass.swift
//  NY_Times_Test_App
//
//  Created by Development  on 09/06/2021.
//

import Foundation
import SafariServices
class GlobalClass {
    
    class func getdateValue(date: String) -> String {
        let dateFormatter = DateFormatter()
          dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            let dateFromString = dateFormatter.date(from: date)!
          dateFormatter.dateFormat = "yyyy-MM-dd"
            let datenew = dateFormatter.string(from: dateFromString)
            return datenew
        }

    
}
