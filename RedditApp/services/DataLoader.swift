//
//  DataLoader.swift
//  RedditApp
//
//  Created by Ілля Сітьков on 02.03.2023.
//

import Foundation

struct DataLoader {
    
    func performGetRequest(url: URL) async -> Data? {
        print("Performing GET request with url '\(url)'")
        let configuration = URLSessionConfiguration.default
        configuration.urlCache = nil
        let session = URLSession(configuration: configuration)
        do {
            let (data, _) = try await session.data(from: url)
            return data
        } catch {
            print("Error: failed to perform GET request with url '\(url)'")
            print(error)
            return nil
        }
    }
    
}

