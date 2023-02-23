//
//  JSONDecoderX.swift
//  RedditApp
//
//  Created by Ілля Сітьков on 24.02.2023.
//

import Foundation


extension JSONDecoder {
    
    func parseJSON<T:Decodable>(_ data: Data, to: T.Type) -> T? {
        self.keyDecodingStrategy = .convertFromSnakeCase
        return try? self.decode(to, from: data)
    }
    
}
