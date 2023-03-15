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
    static let SUBREDDIT = "ios"
    static let LOAD_MORE_POSTS_N = 10
    static let INITIAL_LOAD_POSTS_N = 20
    static let GO_TO_POST_DETAIL_SEGUE_ID = "go_to_post_details"
    static let LOADING_IS_POSSIBLE_RESET_TIME_S = 10.0
}

final class PostListViewController: UIViewController {
    
    @IBOutlet weak var postsTableView: UITableView!
    @IBOutlet weak var subredditLabel: UILabel!
    @IBOutlet weak var showSavedButton: UIButton!
    @IBOutlet weak var textView: UIView!
    @IBOutlet weak var textField: UITextField!
    
    private let stateManager = StateManager.instance
    
    private var lastSelectedPost: Post?
    
    private var showSaved = false
    
    private var searchString = ""
    
    private var previousScrollOffset: CGFloat = 0
    
    private var posts: [Post] {
        if self.showSaved {
            let posts = self.stateManager.savedPosts
            return self.searchString.count > 0 ?
            posts.filter {$0.title.lowercased().contains(searchString.lowercased())}
            : posts
        } else {
            return self.stateManager.loadedPosts
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.stateManager.delegate = self
        self.subredditLabel.text = "/r/\(Const.SUBREDDIT)"
        self.textField.delegate = self
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
    
    func switchMode() {
        self.showSaved = !self.showSaved
        self.textView.isHidden = !self.showSaved
        self.textField.text = ""
        self.searchString = ""
        self.postsTableView.reloadData()
    }
    
    @IBAction func showSavedBtnClicked() {
        switchMode()
        let imageName = self.showSaved ? "bookmark.circle.fill" : "bookmark.circle"
        self.showSavedButton.setImage(UIImage(systemName: imageName), for: .normal)
    }
    
}

//MARK: - PostManagerDelegate
extension PostListViewController: StateManagerDelegate {
    
    func stateUpdated() {
        DispatchQueue.main.async {
            self.postsTableView.reloadData()
        }
    }
    
}

//MARK: - UITableViewDelegate
extension PostListViewController: UITableViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let currentScrollOffset = scrollView.contentOffset.y
        let scrolledDown = currentScrollOffset > self.previousScrollOffset
        self.previousScrollOffset = currentScrollOffset
        guard scrolledDown,
              !self.showSaved,
              let tableView = scrollView as? UITableView,
              let firstVisibleRow = tableView.indexPathsForVisibleRows?.first?.row,
              firstVisibleRow + Const.MIN_NEXT_POSTS_N > self.posts.count,
              !self.stateManager.isLoading && self.stateManager.loadingIsPossible // without it simulator lags even though loadMore() has the same check inside
        else {return}
        print("Load more called, row:\(firstVisibleRow)")
        self.stateManager.handle(action: .loadMore(num: Const.LOAD_MORE_POSTS_N, subreddit: Const.SUBREDDIT))
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.lastSelectedPost = self.posts[indexPath.row]
        self.performSegue(withIdentifier: Const.GO_TO_POST_DETAIL_SEGUE_ID, sender: nil)
    }
    
}

//MARK: - UITableViewDatasource
extension PostListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("numberOfRowsInSection called: \(self.posts.count)")
        return self.posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Const.REUSABLE_CELL_ID, for: indexPath) as! PostCell
        cell.config(with: self.posts[indexPath.row])
        cell.delegate = self
        return cell
    }
    
}

//MARK: - PostViewDelegate
extension PostListViewController: PostViewDelegate {
    func saveButtonClicked(id: String, saved: Bool) {
        if saved {
            self.stateManager.handle(action: .savePost(id: id))
        } else {
            self.stateManager.handle(action: .unsavePost(id: id))
        }
    }
    
    func shareButtonClicked(url: URL) {
        let ac = UIActivityViewController(activityItems: [url], applicationActivities: nil)
        present(ac, animated: true)
    }
}

//MARK: - UITextFieldDelegate
extension PostListViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text as? NSString
        else {return true}
        let input = text.replacingCharacters(in: range, with: string)
        self.searchString = input
        print("searchString='\(self.searchString)'")
        self.postsTableView.reloadData()
        return true
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        self.searchString = ""
        self.postsTableView.reloadData()
        return true
    }
    
}
