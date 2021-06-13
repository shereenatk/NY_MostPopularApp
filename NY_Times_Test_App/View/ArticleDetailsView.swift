//
//  ArticleDetailsView.swift
//  NY_Times_Test_App
//
//  Created by Development  on 09/06/2021.
//

import SwiftUI
import Kingfisher
struct ArticleDetailsView: View  {
    @ObservedObject var listOfArticles = ArticleListViewModel()
   
    var articleDetails : Result
    
    var body: some View {
       
        PushedNavigationView(articleDetails: articleDetails)
       .navigationTitle("\(articleDetails.title ?? "")")
        .navigationBarTitleDisplayMode(.inline)
        
    }
      
  
}




