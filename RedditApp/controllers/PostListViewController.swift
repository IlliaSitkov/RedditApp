//
//  PostListViewController.swift
//  RedditApp
//
//  Created by Ілля Сітьков on 01.03.2023.
//

import Foundation
import UIKit


final class PostListViewController: UIViewController {
    
    struct Const {
        static let REUSABLE_CELL_ID = "post_cell"
    }
    
    @IBOutlet weak var postsTableView: UITableView!
    
    private let postManager = PostManager.instance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.postManager.delegate = self
        self.postManager.loadPostsWithParams(subreddit: "cats", limit: 100)
    }
    
}

//MARK: - PostManagerDelegate
extension PostListViewController: PostManagerDelegate {
    
    func postsUpdated(posts: [Post]) {
        DispatchQueue.main.async {
            print("Reload data called: \(posts.count)")
            self.postsTableView.reloadData()
        }
    }
    
}

//MARK: - UITableViewDelegate
extension PostListViewController: UITableViewDelegate {
    
    
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        let contentOffset = scrollView.contentOffset
//        print("Content offset: \(contentOffset)")
//    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard let tableView = scrollView as? UITableView else {
            return
        }
        
        let visibleIndexPaths = tableView.indexPathsForVisibleRows ?? []
        
        print("Visible cells indexes: \(visibleIndexPaths)")
        if let firstVisibleIndexPath = visibleIndexPaths.first {
            print("First visible cell index: \(firstVisibleIndexPath.row)")
        }
    }
    
}

//MARK: - UITableViewDatasource
extension PostListViewController: UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("numberOfRowsInSection called: \(self.postManager.posts.count)")
        return self.postManager.posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Const.REUSABLE_CELL_ID, for: indexPath) as! PostCell
        cell.config(with: postManager.posts[indexPath.row])
        return cell
    }
    
}

