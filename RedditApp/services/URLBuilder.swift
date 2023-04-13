//
//  URLBuilder.swift
//  RedditApp
//
//  Created by Ілля Сітьков on 23.02.2023.
//

import Foundation

typealias QueryParam = (name: String, value: CustomStringConvertible)

class URLBuilder {
    
    private(set) var scheme: String?
    private(set) var host: String?
    private var _path = [String]()
    private(set) var queryParams = [String:CustomStringConvertible]()
    
    var path: String {
        "/"+self._path.joined(separator: "/")
    }
    
    init(){}
    
    func scheme(_ scheme: String) -> URLBuilder {
        self.scheme = scheme
        return self
    }
    
    func host(_ host: String) -> URLBuilder {
        self.host = host
        return self
    }
    
    func path(_ path: String) -> URLBuilder {
        self._path = path.split(separator: "/").map {String($0)}
        return self
    }
    
    func changePath(to path: String, at index: Int) -> URLBuilder? {
        guard self._path.count > 0 && index >= 0 && index < self._path.count
        else {return nil}
        self._path[index] = path
        return self
    }
    
    func withNew(queryParams: QueryParam...) -> URLBuilder {
        self.queryParams = Dictionary(uniqueKeysWithValues: queryParams)
        return self
    }
    
    func with(queryParams: QueryParam...) -> URLBuilder {
        self.queryParams.merge(queryParams) {$1}
        return self
    }
    
    func removeParams() -> URLBuilder {
        self.queryParams = [:]
        return self
    }
    
    func build() -> URL? {
        var components = URLComponents()
        components.scheme = self.scheme
        components.host = self.host
        components.path = self.path
        components.queryItems = self.queryParams.map {URLQueryItem(name: $0, value: $1.description)}
        return components.url
    }
    
    
}



