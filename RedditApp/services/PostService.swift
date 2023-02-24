//
//  PostService.swift
//  RedditApp
//
//  Created by Ілля Сітьков on 24.02.2023.
//

import Foundation

class PostService: DataLoaderDelegate {

    private var dataLoader = DataLoader()
    private let decoder = JSONDecoder()
    var delegate:DataLoaderDelegate? {
        willSet {
            print("Setting delegate...")
            print(newValue)
        }
        didSet {
            print("DID set")
            print(delegate)
        }
    }
    
    init() {
        self.dataLoader.delegate = self
    }

    
    private let baseUrl = URLBuilder()
        .scheme("https")
        .host("www.reddit.com")
        .path("/r/ios/top.json")
    

    func getPostsWithParams(subreddit: String, limit: Int, after: String = "") {
        guard let url = baseUrl.changePath(to: subreddit, at: 1)?.withNew(queryParams: ("limit", limit), ("after", after)).build()
        else {return}
        print(delegate)
        dataLoader.performRequest(url: url)
        print(delegate)
    }
    
    func postsFetched(posts: PostResponseData) {
        print("Finished1")
        print(delegate)
        delegate?.postsFetched(posts: posts)
        print(posts)
    }
    
    
    
}
