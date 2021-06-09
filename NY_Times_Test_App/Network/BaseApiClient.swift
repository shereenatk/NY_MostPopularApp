//
//  BaseApiClient.swift
//  Fixperts
//
//  Created by Apple on 2/17/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import Foundation
import Alamofire

class BaseAPIClient {
    
    let networkMgr = NetworkManager()
    
    func makeNetworkRequest<Generic: Codable>(requestObj: URLRequestConvertible,
                                              isShowProgress: Bool = true,
                                              isBlockUI: Bool = true,
                                              onCompletion: @escaping (Generic?, ResponseError?) -> Void) {
        
        if NetworkReachability.shared.isNetworkAvailable() {
            networkMgr.request(requestObj: requestObj) { response in
                if let data = response?.data {
                    self.pringJsonStringResponse(forData: data)
                    let itemObj = try? data.decoded() as Generic
                    onCompletion(itemObj, nil)
                    return
                }
                onCompletion(nil, response?.error)
            }
        } else {
            self.showAlertOnTopWindowLayer(title: "offline", message: "no_network")
        }
    }
    
    func makeNativeNetworkRequest<Generic: Codable>(_ urlString: String,
                                                    time: TimeInterval = 60.0,
                                                    methodType: NetworkManagerMethodTypes.RawValue = "GET",
                                                    isBlockUI: Bool = true,
                                                    isShowProgress: Bool = true,
                                                    headers: [String: String]?,
                                                    params: [String: AnyObject]?,
                                                    onCompletion: @escaping (Generic?, ResponseError?) -> Void) {
        
        if NetworkReachability.shared.isNetworkAvailable() {
            networkMgr.callGenericWebServiceWithUrl(urlString, methodType: methodType, headers: headers, params: params) { (data, responseError, _) in
              //  SVProgressHUD.dismiss()
                if let data = data {
                    self.pringJsonStringResponse(forData: data)
                    let itemObj = try? data.decoded() as Generic
                    onCompletion(itemObj, nil)
                    return
                }
                onCompletion(nil, responseError)
            }
            
        } else {
            self.showAlertOnTopWindowLayer(title: "offline", message: "no_network")
        }
        
    }
    
    func pringJsonStringResponse(forData data: Data) {
        guard let strData = NSString(data: data, encoding:String.Encoding.utf8.rawValue) else {
            print("No json string");
            return
        }
    }
    
    func showAlertOnTopWindowLayer(title: String, message: String) {
           
           let alertWindow = UIWindow(frame: UIScreen.main.bounds)
           alertWindow.rootViewController = UIViewController()
           alertWindow.windowLevel = UIWindow.Level.alert + 1
           let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
           let okAction = UIAlertAction(title: "ok", style: .default) { (_) in
               alert.dismiss(animated: true, completion: nil)
           }
           alert.addAction(okAction)
           alertWindow.makeKeyAndVisible()
           alertWindow.rootViewController?.present(alert, animated: true, completion: nil)
       }
    
}

extension Data {
    func decoded<T: Codable>() throws -> T {
        return try JSONDecoder().decode(T.self, from: self)
    }
}
