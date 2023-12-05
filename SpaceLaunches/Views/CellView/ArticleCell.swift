//
//  ArticleCell.swift
//  SpaceLaunches
//
//  Created by Mahaveer Gill on 03/12/2023.
//

import SwiftUI
import Kingfisher

struct ArticleCell: View {
    
    let article: Article
    
    var body: some View {
        VStack {
            HStack {
                VStack(alignment: .leading, spacing: 6) {
                    Group {
                        Text(article.newsSite)
                            .foregroundColor(.secondary)
                        
                        Text(article.title)
                            .bold()
                    }
                    .minimumScaleFactor(0.8)

                    
                    Spacer()
                    
                }
                .frame(height: 120)

                Spacer()
                
                
                KFImage(URL(string: article.imageUrl))
                    .placeholder {
                        ProgressView()
                    }
                    .resizable()
                    .scaledToFill()
                    .frame(width: 120, height: 120)
                    .clipShape(
                        RoundedRectangle(cornerRadius: 15.0)
                    )
                    .padding(.bottom, 9)
                    
                
            }
            
            Divider()
            
            HStack {
                Text(article.publishedAt.timeAgoDisplay())
                    .font(.footnote)
                    .foregroundStyle(.secondary)
                Spacer()
            }
        }
        .padding(11)
        .background {
            Color(uiColor: .secondarySystemFill)
        }
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}

#Preview {
    
    ArticleCell(article: Article.example())
    
}
