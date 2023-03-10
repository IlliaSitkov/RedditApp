//
//  PostStore.swift
//  RedditApp
//
//  Created by Ілля Сітьков on 10.03.2023.
//

import Foundation

final class PostStore {
    
    private let jsonEncoder = JSONEncoder()
    private let jsonDencoder = JSONDecoder()

    private let postStoreFileName = "posts.json"
    private let postStorePath: URL
    
    init() {
        self.postStorePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent(self.postStoreFileName)
    }
    
    func save(posts: [Post]) {
        do {
            let data = try self.jsonEncoder.encode(posts)
            try data.write(to: self.postStorePath)
        } catch {
            print("Posts have not been saved due to an error")
            print(error.localizedDescription)
        }
    }
    
    func readSaved() -> [Post] {
        guard FileManager.default.fileExists(atPath: self.postStorePath.path)
        else {return []}
        do {
            let data = try Data(contentsOf: self.postStorePath)
            return try self.jsonDencoder.decode([Post].self, from: data)
        } catch {
            print("Could not read posts from the file due to an error")
            print(error.localizedDescription)
            return []
        }
    }
    
}
