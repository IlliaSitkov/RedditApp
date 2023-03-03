//
//  PostListViewController.swift
//  RedditApp
//
//  Created by Ілля Сітьков on 01.03.2023.
//

import Foundation
import UIKit

struct Const {
    static let REUSABLE_CELL_ID = "post_cell"
    static let MIN_NEXT_POSTS_N = 5
    static let SUBREDDIT = "cats"
    static let LOAD_MORE_POSTS_N = 10
    static let INITIAL_LOAD_POSTS_N = 20
    static let GO_TO_POST_DETAIL_SEGUE_ID = "go_to_post_details"
}

final class PostListViewController: UIViewController {
    
    @IBOutlet weak var postsTableView: UITableView!
    @IBOutlet weak var subredditLabel: UILabel!

    private let postManager = PostManager.instance
    
    private var lastSelectedPost: Post?
        
    override func viewDidLoad() {
        super.viewDidLoad()
        self.postManager.delegate = self
        self.subredditLabel.text = "/r/\(Const.SUBREDDIT)"
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case Const.GO_TO_POST_DETAIL_SEGUE_ID:
            let nextVc = segue.destination as! PostDetailsViewController
            if let post = lastSelectedPost {
                DispatchQueue.main.async {
                    nextVc.config(with: post)
                }
            }
        default:
            break
        }
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
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard let tableView = scrollView as? UITableView,
              let firstVisibleRow = tableView.indexPathsForVisibleRows?.first?.row,
              firstVisibleRow + Const.MIN_NEXT_POSTS_N > self.postManager.posts.count,
              !self.postManager.isLoading && self.postManager.hasMorePosts
        else {return}
        print("Load more called, row:\(firstVisibleRow)")
        Task {
            await self.postManager.loadMorePosts(subreddit: Const.SUBREDDIT, limit: Const.LOAD_MORE_POSTS_N)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.lastSelectedPost = self.postManager.posts[indexPath.row]
        self.performSegue(withIdentifier: Const.GO_TO_POST_DETAIL_SEGUE_ID, sender: nil)
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

