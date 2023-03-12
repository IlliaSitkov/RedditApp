//
//  StateManager.swift
//  RedditApp
//
//  Created by Ілля Сітьков on 10.03.2023.
//

import Foundation

enum Action {
    
    case initialLoad(num: Int, subreddit: String)
    case loadMore(num: Int, subreddit: String)
    case savePost(id: String)
    case unsavePost(id: String)
    case savePostsLocally
}

protocol StateManagerDelegate: AnyObject {
    func stateUpdated()
}

final class StateManager {
    
    private(set) var loadedPosts = [Post]()
    private(set) var savedPosts = [Post]()
    private(set) var isLoading = false
    private(set) var loadingIsPossible = true {
        didSet {
            if !self.loadingIsPossible {
                DispatchQueue.main.async {
                    Timer.scheduledTimer(
                        timeInterval: Const.LOADING_IS_POSSIBLE_RESET_TIME_S,
                        target: self,
                        selector: #selector(self.enableLoading),
                        userInfo: nil,
                        repeats: false)
                }
            }
        }
    }
    
    private var after: String {
        loadedPosts.last?.name ?? ""
    }
    
    private let postStore = PostStore()
    private let postLoader = PostLoader()
    
    weak var delegate: StateManagerDelegate?
    
    private static var _instance: StateManager?
    
    static var instance: StateManager {
        if let pm = _instance {
            return pm
        } else {
            let pm = StateManager()
            _instance = pm
            return pm
        }
    }
    
    private init() {}
    
    @objc
    private func enableLoading() {
        self.loadingIsPossible = true
    }
    
    func handle(action: Action) {
        switch action {
        case let .initialLoad(num, subreddit):
            Task {
                await performInitialLoad(num: num, subreddit: subreddit)
                notifyDelegateStateUpdated()
            }
        case let .loadMore(num, subreddit):
            Task {
                await loadMorePosts(num: num, subreddit: subreddit)
                notifyDelegateStateUpdated()
            }
        case let .savePost(id):
            savePost(id: id)
            notifyDelegateStateUpdated()
        case let .unsavePost(id):
            unsavePost(id: id)
            notifyDelegateStateUpdated()
        case .savePostsLocally:
            saveSavedPostsToFile()
        }
    }
    
    private func saveSavedPostsToFile() {
        self.postStore.save(posts: self.savedPosts)
    }
    
    private func savePost(id: String) {
        guard let postIndex = self.loadedPosts.firstIndex(where: {$0.id == id})
        else {return}
        self.loadedPosts[postIndex].saved = true
        self.savedPosts.append(self.loadedPosts[postIndex])
    }
    
    private func unsavePost(id: String) {
        self.savedPosts.removeAll(where: {$0.id == id})
        guard let postIndex = self.loadedPosts.firstIndex(where: {$0.id == id})
        else {return}
        self.loadedPosts[postIndex].saved = false
    }
    
    private func performInitialLoad(num: Int, subreddit: String) async {
        self.savedPosts = postStore.readSaved()
        await loadMorePosts(num: num, subreddit: subreddit)
    }

    private func loadMorePosts(num: Int, subreddit: String) async {
        guard !self.isLoading && self.loadingIsPossible
        else {return}
        self.isLoading = true
        defer {
            self.isLoading = false
        }
        guard let loadedPosts = await postLoader.getPostsWithParams(subreddit: subreddit, limit: num, after: after)
        else {
            self.loadingIsPossible = false
            return
        }
        self.loadingIsPossible = loadedPosts.count > 0
        self.loadedPosts.append(contentsOf: markSaved(posts: loadedPosts))
    }
    
    private func markSaved(posts: [Post]) -> [Post] {
        let savedPostsIds = self.savedPosts.map{ $0.id }
        var updatedPosts = posts
        for i in 0..<updatedPosts.count {
            if savedPostsIds.contains(where: { $0 == updatedPosts[i].id }) {
                updatedPosts[i].saved = true
            }
        }
        return updatedPosts
    }
    
    private func notifyDelegateStateUpdated() {
        if let delegate = self.delegate {
            delegate.stateUpdated()
        }
    }
    
    
    
    
}
