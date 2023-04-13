//
//  Comment.swift
//  RedditComments
//
//  Created by Ілля Сітьков on 29.03.2023.
//

import Foundation


struct CommentData: Codable {
    
    let data: Comment
    
}

struct Comment: Codable, Identifiable {
    
    let id: String
    let body: String
    let created: Double
    let author: String
    let ups: Int
    let downs: Int
    let subreddit: String
    let parentId: String
    var rating: Int {
        ups - downs
    }
    var createdAgo: String {
        Date.convert(time: Date().timeIntervalSince1970 - self.created)
    }
    var url: String {
        "https://www.reddit.com/r/\(self.subreddit)/comments/\(self.parentId.dropFirst(3))/comment/\(self.id)"
    }
    
}
