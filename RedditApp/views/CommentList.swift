//
//  CommentList.swift
//  RedditComments
//
//  Created by Ілля Сітьков on 01.04.2023.
//

import SwiftUI

struct CommentList: View {
    
    struct Const {
        static let MIN_CELL_OPACITY = 0.5
        static let MAX_OPACITY = 1.0
        static let ANIMATION_DURATION = 0.15
        static let COMMENTS_LIMIT = 100
    }
    
    private let subreddit: String
    private let postId: String
    private let handleTap: (Comment) -> Void
    
    init(subreddit: String, postId: String, handleTap: @escaping (Comment) -> Void) {
        self.subreddit = subreddit
        self.postId = postId
        self.handleTap = handleTap
    }
    
    @StateObject var commentLoader = CommentLoader()
    @ScaledMetric(relativeTo: .body) var padding = 6
    @State private var selectedCommentId: String?
    @State private var cellOpacity = 1.0
    
    var body: some View {
        VStack {
            Text("Comments")
                .font(.title2)
                .fontWeight(.semibold)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 8)
            ScrollView {
                LazyVStack {
                    ForEach(commentLoader.comments) { comment in
                        self.commentCell(comment: comment)
                    }
                }
            }
        }
        .task {
            await self.commentLoader.getPostComments(subreddit: self.subreddit, postId: self.postId, limit: Const.COMMENTS_LIMIT)
        }
    }
    
    @ViewBuilder
    private func commentCell(comment: Comment) -> some View {
        VStack {
            HStack {
                Text(comment.author)
                    .fontWeight(.semibold)
                + Text(" • "+comment.createdAgo)
                    .foregroundColor(Color.grey)
                Spacer()
            }
            .font(.subheadline)
            Text(comment.body)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.top, 4)
            HStack{
                Label(comment.rating.description, systemImage: "arrow.up.heart")
                    .foregroundColor(.accentColor)
                Spacer()
            }
            .padding(.top, 8)
        }
        .opacity(comment.id == self.selectedCommentId ? cellOpacity : Const.MAX_OPACITY)
        .padding()
        .background(Color.lightGrey)
        .cornerRadius(16)
        .padding(8)
        .animation(.easeIn(duration: Const.ANIMATION_DURATION), value: self.cellOpacity)
        .onTapGesture {
            self.selectedCommentId = comment.id
            self.cellOpacity = Const.MIN_CELL_OPACITY
            DispatchQueue.main.asyncAfter(deadline: .now()+Const.ANIMATION_DURATION) {
                self.cellOpacity = Const.MAX_OPACITY
                handleTap(comment)
            }
        }
    }
    
}

//struct CommentList_Previews: PreviewProvider {
//    static var previews: some View {
//        CommentList()
//    }
//}

extension Color {
    
    static let lightGrey = Color(red: 242/255, green: 242/255, blue: 247/255)
    static let grey = Color(red: 123/255, green: 123/255, blue: 123/255)
    
}
