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
    private let dataLoader = DataLoader()
    
    var delegate: PostManagerDelegate?
    
    private(set) var posts = [Post]()
    
    private var after: String {
        posts.last?.name ?? ""
    }
    
    private(set) var isLoading = false
    private(set) var hasMorePosts = true
    
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
    
    func loadMorePosts(subreddit: String, limit: Int) async {
        print("loadMorePosts called")
        self.isLoading = true
        defer {
            self.isLoading = false
        }
        guard let posts = await self.getPostsWithParams(subreddit: subreddit, limit: limit, after: self.after)
        else {return}
        self.hasMorePosts = posts.count > 0
        self.posts.append(contentsOf: posts)
        self.notifyDelegatePostsUpdated()
    }
    
    func loadPostsWithParams(subreddit: String, limit: Int, after: String = "") async {
        print("loadPostsWithParams called")
        self.isLoading = true
        defer {
            self.isLoading = false
        }
        guard let posts = await self.getPostsWithParams(subreddit: subreddit, limit: limit, after: after)
        else {return}
        self.posts = posts
        self.notifyDelegatePostsUpdated()
    }
    
    private func notifyDelegatePostsUpdated() {
        if let delegate = self.delegate {
            delegate.postsUpdated(posts: self.posts)
        }
    }
    
    func getPostsWithParams(subreddit: String, limit: Int, after: String) async -> [Post]?  {
        guard let url = baseUrl.changePath(to: subreddit, at: 1)?.withNew(queryParams: ("limit", limit), ("after", after)).build(),
              let data = await dataLoader.performGetRequest(url: url),
              let decoded = self.decoder.parseJSON(PostResponseData.self, from: data)
        else {return nil}
        return decoded.data.children.map {$0.data}
    }
    
    
}
