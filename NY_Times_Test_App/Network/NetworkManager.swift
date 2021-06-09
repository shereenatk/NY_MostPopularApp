//
//  NetworkManager.swift
//  NY_Times_Test_App
//
//  Created by Development  on 09/06/2021.
//

import Foundation
import Alamofire

protocol NetworkCallBacks {
    typealias  ServiceResponse = (ResponseSuccess?) -> Void
    typealias  InProgress =  (Double) -> Void
}

enum NetworkManagerMethodTypes: String {
    case GET, POST, PUT, DELETE
}

class  NetworkManager {
    /**
     Request  method
     - parameter request:  URLRequestConvertible
     - parameter ServiceResponse: closure
     */
    func request(requestObj: URLRequestConvertible, onCompletion: @escaping NetworkCallBacks.ServiceResponse) {
        Alamofire.request(requestObj ).validate().responseString { response in
            switch response.result {
            case .success:
                
                if let json = response.result.value {
                    print("JSON: \(json)") // serialized json response
                }
                let resp = self.complete(response.request, response: response.response, inJSON: response.result.value, inData: response.data, error: nil)
                onCompletion(resp)
                
            case .failure(let error):
                print(error)
                let resp = self.complete(response.request, response: response.response, inJSON: response.result.value, inData: nil, error: error)
                /*if response.response?.statusCode == AppAttributes.sharedInstance.statusCodeToBlock {
                    AppAttributes.sharedInstance.showAppBlockAlert()
                }*/
                onCompletion(resp)
                return
            }
        }
    }
    
    func callGenericWebServiceWithUrl(_ urlString: String,
                                      time: TimeInterval = 60.0,
                                      methodType: NetworkManagerMethodTypes.RawValue = "GET",
                                      headers: [String: String]?,
                                      params: [String: AnyObject]?,
                                      completionHandler: @escaping (Data?, _ error: ResponseError?, _ response: URLResponse?) -> Void) {
        
        let session = URLSession.shared
        let finalUrl = urlString
        guard let url: URL = URL(string: finalUrl) else { return }
        var request: URLRequest = URLRequest(url: url, cachePolicy: NSURLRequest.CachePolicy.reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: time)
        // Setting HTTP Method Type
        request.httpMethod = methodType
        // Setting Header
        if let unHeaders = headers {
            request.allHTTPHeaderFields = unHeaders
        }
        // Adding parsm in body
        if let unwarp = params {
            request.httpBody = try? JSONSerialization.data(withJSONObject: unwarp, options: .prettyPrinted)
            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: unwarp, options: JSONSerialization.WritingOptions.init(rawValue: 2))
            } catch {
                // Error Handling
                print("NSJSONSerialization Error")
                return
            }
        }
        // Starting the session
        session.dataTask(with: request, completionHandler: { (data: Data?, response: URLResponse?, error: Error?) in
            guard let urlResponse = response as? HTTPURLResponse else { return }
            let responseError = ResponseError(error: "Unknown \(urlResponse.statusCode)")
            guard let data = data else { completionHandler(nil, responseError, response); return }
            // THIS WILL BE REQUIRED IN FUTURE
            //                let strData = NSString(data: data, encoding: String.Encoding.utf8.rawValue)
            //                print(strData)
            completionHandler(data, responseError, response)
            
        }).resume()
    }
    
    /**
     Request  method
     - parameter downloadURL:  URL
     - parameter sourceurl: String
     - parameter inProgress: closure
     - parameter onCompletion: closure
     */
    func downloadRequest(downloadURL: URL, from urlString: String, inProgress: @escaping NetworkCallBacks.InProgress, onCompletion: @escaping NetworkCallBacks.ServiceResponse) {
        let destination: DownloadRequest.DownloadFileDestination = { _, _ in
            return (downloadURL, [.removePreviousFile, .createIntermediateDirectories])
        }
        
        Alamofire.download(urlString, to: destination)
            .downloadProgress { progress in
                print("Download Progress: \(progress.fractionCompleted)")
                inProgress(progress.fractionCompleted)
            }
            .response { response in
                let resp = self.complete(response.request, response: response.response, inJSON: nil, inData: nil, error: response.error)
                onCompletion(resp )
                print(response)
        }
    }
    /**
     Request complete processor
     
     - parameter request:  URLRequest
     - parameter response: HTTPURLResponse
     - parameter JSON:     Response object
     - parameter inData:   Data object
     - parameter error:    Error
     - parameter complete: closure
     */
    fileprivate func complete(_ request: URLRequest?, response: HTTPURLResponse?, inJSON: Any?, inData: Data?, error: Error?) -> ResponseSuccess {
        let responseSucess = ResponseSuccess(URLRequest: request, response: response)
        if let status = response?.statusCode {
            responseSucess.statusCode = status
        }
        if let json = inJSON {
            responseSucess.JSON = json
        }
        if let data = inData {
            responseSucess.data = data
        }
        if let nsError = error {
            responseSucess.error = ResponseError(error: nsError.localizedDescription)
        } else if responseSucess.error == nil {
            responseSucess.error = ResponseError(error: "Unknown \(responseSucess.statusCode)")
        }
        responseSucess.error?.statusCode = response?.statusCode ?? 0
        return responseSucess
    }
}
