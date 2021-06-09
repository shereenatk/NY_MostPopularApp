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
      
    struct PushedNavigationView: View {
        let articleDetails : Result
        @State var showSafari = false
        @State var index = 0
        var body: some View {
            ScrollView {
                VStack(alignment: .leading) {
                    let maxLimit = articleDetails.media?[0].mediaMetadata.count ?? 0
                    let urlList = [articleDetails.media?[0].mediaMetadata[0].url ?? "" , articleDetails.media?[0].mediaMetadata[1].url ?? "", articleDetails.media?[0].mediaMetadata[2].url ?? ""]
                    if( maxLimit > 0  ) {
                        PagingView(index: $index.animation(), maxIndex: maxLimit - 1) {
                            ForEach(urlList, id: \.self) { url in
                                        KFImage(URL(string: url ))
                                            .resizable()
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .frame(width: UIScreen.main.bounds.width, height: 200)
                                            .background(Color(AppColor.backgoundWhite.cgColor))
                                       }
                                   }
                                   .aspectRatio(4/3, contentMode: .fit)
                                   .clipShape(RoundedRectangle(cornerRadius: 15))
                       
                            .overlay(Group {
                                        
                                    ZStack {
                                        HStack{
                                            Button(action: {HSHosting.openSafari(url:URL(string: "\(articleDetails.url ?? "")")!)}) {
                                               Image("openbook")
                                            }.padding(.trailing, 5)
                                            .alignmentGuide(.bottom) { $0[.bottom] }
                                            Button(action: {actionSheet(url: "\(articleDetails.url ?? "")")}) {
                                               Image( "share")
                                                    .foregroundColor(.red).font(.title)
                                            }.padding(.trailing, 5)
                                            .alignmentGuide(.bottom) { $0[.bottom] }
                                        }
                                        
                                    }.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
                                ZStack {
                                    HStack{
                                        Text("\(articleDetails.section ?? "")" + " - " + "\(articleDetails.subsection ?? "")")
                                            .font(.system(size: 12, weight: .medium))
                                            .padding(.trailing, 5)
                                            .frame(width:150 , height: (30.0))
                                            .background(Color(AppColor.primaryColor.value))
                                            .cornerRadius(15)
                                        .alignmentGuide(.bottom) { $0[.bottom] }
                                    }
                                    
                                }.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomLeading)

                                        
                                   })
                                   .padding(.bottom, 20)
                      
                    } else {
                        Image("placeholder")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: UIScreen.main.bounds.width, height: 100)
                            .background(Color(AppColor.backgoundWhite.cgColor))
                    }
                    Text(articleDetails.title ?? "").padding(3)
                      
                    Text(getAddKeyword(keywords: "\(articleDetails.adxKeywords ?? "")"))
                      .font(.system(size: 12))
                      .foregroundColor(Color.blue)
                        .multilineTextAlignment(.leading).padding(3)
                    
                    Text("\(articleDetails.byline ?? "")")
                      .font(.system(size: 14))
                      .foregroundColor(Color.gray)
                      .multilineTextAlignment(.leading).padding(3)
                      HStack( spacing: 10) {
                           
                        Text("Published On: ").font(.system(size: 12, weight: .medium))  +  Text("\(articleDetails.publishedDate ?? "")").font(.system(size: 12,weight: .medium))
                            .foregroundColor(Color.gray)
                             
                        Text("Updated On: ") .font(.system(size: 12, weight: .medium))  +  Text("\(GlobalClass.getdateValue(date: articleDetails.updated ?? ""))")
                            
                              .font(.system(size: 12))
                              .foregroundColor(Color.gray)
                        
                      }
                    Divider()
                    
                    Text("Abstract ").font(.system(size: 15, weight: .medium)).padding(3)
                    Text(articleDetails.abstract ?? "").font(.system(size: 13)).padding(3)

                }
                
            }
            
        }
        
        private func actionSheet(url: String) {
            let activityVC = UIActivityViewController(activityItems: [url], applicationActivities: nil)
            UIApplication.shared.windows.first?.rootViewController?.present(activityVC, animated: true, completion: nil)
        }
        
        private func getAddKeyword(keywords: String) -> String {
            let newString = keywords.replacingOccurrences(of: ";", with: " #", options: .literal, range: nil)
           return "#" + newString
        }
     
    }

}




