//
//  PostService.swift
//  RedditApp
//
//  Created by Ілля Сітьков on 24.02.2023.
//

import Foundation

struct PostService {
    
    private let dataLoader = DataLoader()
    private let decoder = JSONDecoder()
    
    private let baseUrl = URLBuilder()
        .scheme("https")
        .host("www.reddit.com")
        .path("/r/ios/top.json")
    

    func getPostsWithParams(subreddit: String, limit: Int, after: String = "") async {
        guard let url = baseUrl.changePath(to: subreddit, at: 1)?.withNew(queryParams: ("limit", limit), ("after", after)).build(),
              let data = await dataLoader.get(url: url),
              let postResponse: PostResponseData = decoder.parseJSON(data, to: PostResponseData.self)
        else {return nil}
        return postResponse
    }
    
    
    
}
