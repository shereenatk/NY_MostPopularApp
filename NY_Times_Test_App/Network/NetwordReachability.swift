//
//  NetwordReachability.swift
//  NY_Times_Test_App
//
//  Created by Development  on 09/06/2021.
//

import Foundation
import Alamofire

final class NetworkReachability {
    
    //shared instance
    static let shared = NetworkReachability()
    
    var currentStatus: NetworkReachabilityManager.NetworkReachabilityStatus?
    
    private init() { }
    
    let reachabilityMgr = Alamofire.NetworkReachabilityManager(host: "www.google.com")
    
    func startNetworkReachabilityObserver() {
        
        weak var weakSelf = self
        
        reachabilityMgr?.listener = { status in
            
            weakSelf?.currentStatus = status
            
            switch status {
                
            case .notReachable:
                print("The network is not reachable")
                
            case .unknown :
                print("It is unknown whether the network is reachable")
                
            case .reachable(.ethernetOrWiFi):
                print("WiFi connection ON ")
                
            case .reachable(.wwan):
                print("WWAN connection ON")
                
            }
        }
        // start listening
        reachabilityMgr?.startListening()
    }
    
    func isNetworkAvailable() -> Bool {
        if let isReachable = reachabilityMgr?.isReachable {
            return isReachable
        }
        return false
    }
}

