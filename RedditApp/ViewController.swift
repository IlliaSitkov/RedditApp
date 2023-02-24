//
//  ViewController.swift
//  RedditApp
//
//  Created by Ілля Сітьков on 23.02.2023.
//

import UIKit
import SDWebImage

class ViewController: UIViewController, PostManagerDelegate {
    
    var service = PostManager()
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var domainLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var commentsBtn: UIButton!
    @IBOutlet weak var likesLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var bookmarkBtn: UIButton!
    @IBOutlet weak var timeLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        service.delegate = self
        service.getPostsWithParams(subreddit: "ios", limit: 1)
    }
    
    func postsFetched(posts: PostResponseData) {
        let post = posts.data.children[0].data;
        DispatchQueue.main.async {
            self.titleLabel.text = post.title
            self.timeLabel.text = self.convert(time: Date().timeIntervalSince1970 - Double(post.created))
            self.domainLabel.text = post.domain
            self.authorLabel.text = post.username
            self.likesLabel.text = String(post.ups - post.downs)
            self.commentsBtn.setTitle(String(post.numComments), for: .normal)
            self.imageView.sd_setImage(with: URL(string: post.preview.images[0].source.url.replacingOccurrences(of: "amp;", with: "")), placeholderImage: nil)
            self.bookmarkBtn.setImage(UIImage(systemName: post.saved ? "bookmark.fill" : "bookmark"), for: .normal)
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

