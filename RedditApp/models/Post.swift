//
//  Post.swift
//  RedditApp
//
//  Created by Ілля Сітьков on 23.02.2023.
//

import Foundation


struct PostResponseData: Decodable {
    let data: Posts
}
struct Posts: Decodable {
    let children: [PostData]
}
struct PostData: Decodable {
    let data: Post
}

struct Post: Decodable {
    
    let username: String
    let domain: String
    let title: String
    let preview: PreviewImages
    let numComments: String
    let ups: Int
    let downs: Int
    
    enum CodingKeys: String, CodingKey {
        case domain,title,ups,downs,numComments,preview
        case username = "author_fullname"
    }
}
struct PreviewImages: Decodable {
    let images: [Image]
}

struct Image: Decodable {
    let source: ImageSource
}

struct ImageSource: Decodable {
    let url: String
}


