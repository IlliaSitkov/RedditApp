//
//  PostLoader.swift
//  RedditApp
//
//  Created by Ілля Сітьков on 10.03.2023.
//

import Foundation

final class PostLoader {
    
    private let decoder = JSONDecoder()
    private let dataLoader = DataLoader()

    private let baseUrl = URLBuilder()
        .scheme("https")
        .host("www.reddit.com")
        .path("/r/ios/top.json")
    
    func getPostsWithParams(subreddit: String, limit: Int, after: String) async -> [Post]?  {
        guard let url = baseUrl.changePath(to: subreddit, at: 1)?.withNew(queryParams: ("limit", limit), ("after", after)).build(),
              let data = await dataLoader.performGetRequest(url: url),
              let decoded = self.decoder.parseJSON(PostResponseData.self, from: data)
        else {return nil}
        return decoded.data.children.map {$0.data}
    }
    
    
}
