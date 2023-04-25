//
//  JSONDecoderX.swift
//  RedditApp
//
//  Created by Ілля Сітьков on 24.02.2023.
//

import Foundation


extension JSONDecoder {
    
    func parseJSON<T:Decodable>(_ to: T.Type, from data: Data) -> T? {
        self.keyDecodingStrategy = .convertFromSnakeCase
        do {
            return try self.decode(to, from: data)
        } catch {
            print(error)
            return nil
        }
    }
    
}
