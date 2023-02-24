//
//  DataLoader.swift
//  RedditApp
//
//  Created by Ілля Сітьков on 23.02.2023.
//

import Foundation


protocol DataLoaderDelegate {
    func postsFetched(posts: PostResponseData)
}


class DataLoader {
    
    private let decoder = JSONDecoder()
    var delegate:DataLoaderDelegate?
    
    func performRequest(url: URL) {
        let session  = URLSession(configuration: .default)
        let task = session.dataTask(with: url) { data, response, error in
            guard let data = data
            else {
                print("error")
                return
            }
            
            guard let delegate = self.delegate else {
                print("error2")
                return
            }
            guard let decoded = self.decoder.parseJSON(PostResponseData.self, from: data)
            else {
                print("error3")
                return
            }
            print("Finished 0")
            delegate.postsFetched(posts: decoded)
        }
        task.resume()
    }
    
    
}
