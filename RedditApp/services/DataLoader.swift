//
//  DataLoader.swift
//  RedditApp
//
//  Created by Ілля Сітьков on 23.02.2023.
//

import Foundation

protocol Loader {
    
    associatedtype DataType: Decodable
    func load(url: URL) async -> DataType?
}


struct DataLoader<DataType: Decodable>: Loader {
    
    func load(url: URL) async -> DataType? {
        let session = URLSession(configuration: .default)
        do {
            let (data, _) = try await session.data(from: url)
            return self.parseJSON(data)
        } catch {
            print(error)
            return nil
        }
    }
    
    func parseJSON(_ data: Data) -> DataType? {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return try? decoder.decode(DataType.self, from: data)
    }
    
    
}
