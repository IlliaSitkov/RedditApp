//
//  CommentDetail.swift
//  RedditComments
//
//  Created by Ілля Сітьков on 01.04.2023.
//

import SwiftUI

struct CommentDetail: View {
    
    let comment: Comment
    
    var body: some View {
        VStack {
            VStack {
                HStack {
                    Text(self.comment.author)
                        .fontWeight(.semibold)
                    Spacer()
                    Text(self.comment.createdAgo)
                        .foregroundColor(Color.grey)
                }
                .font(.subheadline)
                Text(self.comment.body)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.top, 4)
                HStack{
                    Text("Rating: \(self.comment.rating.description)")
                        .foregroundColor(.accentColor)
                    Spacer()
                }
                .padding(.top, 8)
                ShareLink(item: self.comment.url) {
                    Text("Share")
                        .frame(maxWidth: .infinity)
                        .foregroundColor(.white)
                        .padding(.vertical, 8)
                        .background(Color.accentColor)
                        .cornerRadius(16)
                        .padding(.top, 8)
                }
            }
            .padding()
            .background(Color.lightGrey)
            .cornerRadius(16)
            .padding(8)
            Spacer()
        }
        .navigationTitle(comment.author)
        .navigationBarTitleDisplayMode(.inline)
    }
}

//struct CommentDetail_Previews: PreviewProvider {
//    static var previews: some View {
//        CommentDetail()
//    }
//}
