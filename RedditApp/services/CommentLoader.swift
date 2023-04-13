//
//  PostLoader.swift
//  RedditApp
//
//  Created by Ілля Сітьков on 10.03.2023.
//

import Foundation

final class CommentLoader: ObservableObject {
    
    private let decoder = JSONDecoder()
    private let dataLoader = DataLoader()
    
    @Published private(set) var comments = [Comment]()
    
    private let baseUrl = URLBuilder()
        .scheme("https")
        .host("www.reddit.com")
        .path("/r/ios/comments/123/.json")
    
    func getPostComments(subreddit: String, postId: String, limit: Int) async {
        guard let url = baseUrl.changePath(to: subreddit, at: 1)?.changePath(to: postId, at: 3)?.withNew(queryParams: ("limit", limit), ("depth", 1)).build(),
              let data = await dataLoader.performGetRequest(url: url),
              let comments = parseComments(from: data)
        else {return}
        DispatchQueue.main.async {
            self.comments = comments
        }
    }
    
    private func parseComments(from data: Data) -> [Comment]? {
        let capturePattern = #"(\[\{"kind": "t1".+?(?=(, \{"kind": "more".*\})|(], "before": null\}\}\])))"#
        guard let dataString = String(data: data, encoding: .utf8),
              let captureRegex = try? NSRegularExpression(
                  pattern: capturePattern,
                  options: []
              )
        else {return nil}
        let range = NSRange(
            dataString.startIndex..<dataString.endIndex,
            in: dataString
        )
        let matches = captureRegex.matches(
            in: dataString,
            options: [],
            range: range
        )
        guard let match = matches.first else {
            return nil
        }
        var captures: [String] = []

        for i in 0..<match.numberOfRanges {
            let matchRange = match.range(at: i)
            
            // Ignore matching the entire username string
            if matchRange == range { continue }
            
            // Extract the substring matching the capture group
            if let substringRange = Range(matchRange, in: dataString) {
                let capture = String(dataString[substringRange])
                captures.append(capture)
            }
        }
        guard let capture = captures.first,
              let newData = (capture+"]").data(using: .utf8)
        else {return nil}
        
        let decoder = JSONDecoder()
        let comments = decoder.parseJSON([CommentData].self, from: newData)
        return comments?.map {$0.data}
    }
    
    
}
