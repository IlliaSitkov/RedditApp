//
//  PostService.swift
//  RedditApp
//
//  Created by Ілля Сітьков on 24.02.2023.
//

import Foundation

protocol PostManagerDelegate {
    func postsUpdated(posts: [Post])
}

final class PostManager {

    private let decoder = JSONDecoder()
    var delegate: PostManagerDelegate?
    
    private(set) var posts = [Post]()
    private var after = ""
    
    private static var _instance: PostManager?
    
    static var instance: PostManager {
        if let pm = _instance {
            return pm
        } else {
            let pm = PostManager()
            _instance = pm
            return pm
        }
    }
    
    private init() {}

    private let baseUrl = URLBuilder()
        .scheme("https")
        .host("www.reddit.com")
        .path("/r/ios/top.json")
    
//    func loadMorePosts(subreddit: String, limit: Int) {
//        loadPostsWithParams(subreddit: sub, limit: )
//    }
//
    func loadPostsWithParams(subreddit: String, limit: Int, after: String = "") {
        guard let url = baseUrl.changePath(to: subreddit, at: 1)?.withNew(queryParams: ("limit", limit), ("after", after)).build()
        else {return}
        self.performRequest(url: url)
    }
    
    private func performRequest(url: URL) {
        let session  = URLSession(configuration: .default)
        let task = session.dataTask(with: url) { data, response, error in
            guard let data = data,
                  let delegate = self.delegate,
                  let decoded = self.decoder.parseJSON(PostResponseData.self, from: data)
            else {
                print("Error while performing the request: \(url)")
                return
            }
            let posts = decoded.data.children.map {$0.data}
            self.posts = posts
            delegate.postsUpdated(posts: posts)
        }
        task.resume()
    }
    
    
}
