//
//  DataLoader.swift
//  RedditApp
//
//  Created by Ілля Сітьков on 23.02.2023.
//

import Foundation


struct DataLoader {
    
    func get(url: URL) async -> Data? {
        let session = URLSession(configuration: .default)
        do {
            let (data, _) = try await session.data(from: url)
            return data
        } catch {
            print(error)
            return nil
        }
    }
    

    
}
