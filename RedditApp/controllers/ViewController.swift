//
//  ViewController.swift
//  RedditApp
//
//  Created by Ілля Сітьков on 23.02.2023.
//

import UIKit
import SDWebImage

class ViewController: UIViewController, PostManagerDelegate {
    
    var service = PostManager.instance
    
    let bookmarkSet = UIImage(systemName: "bookmark.circle.fill") ?? UIImage(systemName: "bookmark.fill")
    let bookmarkUnset = UIImage(systemName: "bookmark.circle") ?? UIImage(systemName: "bookmark")
    
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var authorLabel: UILabel!
    @IBOutlet private weak var commentsBtn: UIButton!
    @IBOutlet private weak var likesLabel: UILabel!
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var bookmarkBtn: UIButton!
    @IBOutlet private weak var upvotesImg: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        commentsBtn.setImage(UIImage(systemName: "plus.message"), for: .normal)
        upvotesImg.image = UIImage(systemName: "arrow.up.heart")
        
        service.delegate = self
        Task {
            await service.loadPostsWithParams(subreddit: "nature", limit: 1)
        }
    }
    
    func postsUpdated(posts: [Post]) {
        guard posts.count > 0 else {return}
        let post = posts[0];
        DispatchQueue.main.async {
            self.titleLabel.text = post.title
            let time = self.convert(time: Date().timeIntervalSince1970 - Double(post.created))
            let domain = post.domain
            self.authorLabel.text = "\(post.username) • \(time) • \(domain)"
            self.likesLabel.text = String(post.ups - post.downs)
            self.commentsBtn.setTitle(String(post.numComments), for: .normal)
            if let preview = post.preview, preview.images.count > 0 {
                self.imageView.sd_setImage(with: URL(string: preview.images[0].source.url.replacingOccurrences(of: "amp;", with: "")), placeholderImage: nil)
            }
            self.bookmarkBtn.setImage(post.saved ? self.bookmarkSet : self.bookmarkUnset, for: .normal)
        }
    }
    
    func convert(time: Double) -> String {
        var oldTime = time
        var newTime = time / 60.0
        if (newTime < 1) {
            return "\(Int(oldTime)) s"
        }
        oldTime = newTime
        newTime = oldTime / 60.0
        if (newTime < 1) {
            return "\(Int(oldTime)) m"
        }
        oldTime = newTime
        newTime = oldTime / 24.0
        if (newTime < 1) {
            return "\(Int(oldTime)) h"
        }
        return "\(Int(newTime)) d"
    }
    
    
    
    
}

