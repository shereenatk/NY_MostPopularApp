//
//  ArticleListViewModel.swift
//  NY_Times_Test_App
//
//  Created by Development  on 08/06/2021.
//

import Foundation
import Combine
class ArticleListViewModel :NSObject,ObservableObject {
    fileprivate let client = BaseAPIClient()
    var objectWillChange = PassthroughSubject<Void, Never>()
    var responseStatus : [Result] = .init() {
        didSet {
            objectWillChange.send()
        }
    }
    
    func getArticleList( onCompletion: @escaping (_ isSuccess: Bool, _ errorMessage: (ResponseError?)) -> Void) {
        var paramDict = [String: Any]()
        paramDict = [
            "api-key": AppConstants.apiKey
                     ]
           client.makeNetworkRequest(requestObj: PageRouter.getArticleList(paramDict))  { (response: ArticleModel?, error) in
                    if let error = error { DispatchQueue.main.async {onCompletion(false, error)}; return }
            self.responseStatus = (response?.results)!
             DispatchQueue.main.async {onCompletion(false, nil)}
                return
                
        }
    }
    
}
