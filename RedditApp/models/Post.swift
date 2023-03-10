//
//  Post.swift
//  RedditApp
//
//  Created by Ілля Сітьков on 23.02.2023.
//

import Foundation


struct PostResponseData: Codable {
    let data: Posts
}
struct Posts: Codable {
    let children: [PostData]
}
struct PostData: Codable {
    let data: Post
}

struct Post: Codable {
    
    let id: String
    let username: String
    let domain: String
    let title: String
    let preview: PreviewImages?
    let numComments: Int
    let ups: Int
    let downs: Int
    let created: Int
    var saved: Bool
    let name: String
    let url: String
    
    enum CodingKeys: String, CodingKey {
        case domain,title,ups,downs, numComments,preview,created,name,url,id,saved
        case username = "authorFullname"
    }
}
struct PreviewImages: Codable {
    let images: [Image]
}

struct Image: Codable {
    let source: ImageSource
    let resolutions: [Resolution]
}

struct ImageSource: Codable {
    let url: String
}

struct Resolution: Codable {
    let url: String
    let width: Int
    let height: Int
}

