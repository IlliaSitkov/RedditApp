//
//  PostService.swift
//  RedditApp
//
//  Created by Ілля Сітьков on 24.02.2023.
//

import Foundation

protocol PostManagerDelegate {
    func postsFetched(posts: PostResponseData)
}

class PostManager {

    private let decoder = JSONDecoder()
    var delegate: PostManagerDelegate?

    private let baseUrl = URLBuilder()
        .scheme("https")
        .host("www.reddit.com")
        .path("/r/ios/top.json")
    

    func getPostsWithParams(subreddit: String, limit: Int, after: String = "") {
        guard let url = baseUrl.changePath(to: subreddit, at: 1)?.withNew(queryParams: ("limit", limit), ("after", after)).build()
        else {return}
        self.performRequest(url: url)
    }
    
    func performRequest(url: URL) {
        let session  = URLSession(configuration: .default)
        let task = session.dataTask(with: url) { data, response, error in
            guard let data = data,
                  let delegate = self.delegate,
                  let decoded = self.decoder.parseJSON(PostResponseData.self, from: data)
            else {
                print("Error while performing the request: \(url)")
                return
            }
            delegate.postsFetched(posts: decoded)
        }
        task.resume()
    }
    
    
}
