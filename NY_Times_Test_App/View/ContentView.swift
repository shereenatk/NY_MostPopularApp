//
//  ContentView.swift
//  NY_Times_Test_App
//
//  Created by Development  on 08/06/2021.
//

import SwiftUI
import Kingfisher
struct ContentView: View {
    @ObservedObject var listOfArticles = ArticleListViewModel()
    @State var articleList = [Result]()
    @State var animate = true
    let dateFormatter = DateFormatter()
    
    var body: some View {
        NavigationView{
            List (listOfArticles.responseStatus) { article in
                
                ZStack{
                    
                                   
                    NavigationLink(destination: ArticleDetailsView(articleDetails: article)) {
                        EmptyView()
                    }.opacity(0.0)
                    .buttonStyle(PlainButtonStyle())
                    
                    HStack(spacing: 6) {
                      if( article.media!.count > 0  ) {
                          KFImage(URL(string: article.media?[0].mediaMetadata[0].url! ?? "" )).frame(width: 75.0, height: 75.0)
                              .clipShape(Circle())
                              .clipShape(Circle())
                              .overlay(Circle().stroke(Color.gray, lineWidth: 1))
                        
                      } else {
                          Image("placeholder")
                              .resizable().resizable()
                              .scaledToFit()
                              .frame(width: 75.0, height: 75.0)
                              .clipShape(Circle())
                              .overlay(Circle().stroke(Color.gray, lineWidth: 1))
                      }
                        VStack(alignment: .leading, spacing: 6) {
                          Text(article.title ?? "")
                            .lineLimit(2)
                            
                          Text("\(article.byline ?? "")")
                            .font(.system(size: 14))
                            .foregroundColor(Color.gray)
                            .multilineTextAlignment(.leading)
                            HStack {
                                           
                                Spacer()
                                Text(Image(systemName: "calendar"))
                                Text("\( article.publishedDate ?? "")")
                                    .font(.system(size: 14))
                                    .foregroundColor(Color.gray)
                              .frame(alignment: .trailing)
                            }

                          
                        }
                        
                  }

                }
            }.listStyle(PlainListStyle())
               
            .navigationBarTitle(Text("NY Times Most Popular"), displayMode: .inline)
            .navigationBarItems(leading: HStack {
                Button(action: {}, label: {Image( "menu")})
               
            }, trailing: HStack {
               
                Button(action: {}, label: {Image(systemName: "magnifyingglass")})
                Button(action: {}, label: {Image("threedot")})
            })
            
        }.onAppear(){
            self.listOfArticles.getArticleList(){  isSuccess, errorMessage  in
                self.animate = false
        }
    }
    }
    
}
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ActivityIndicator()
              .frame(width: 50, height: 50)
              .foregroundColor(.blue)
        ContentView()
    }
}

