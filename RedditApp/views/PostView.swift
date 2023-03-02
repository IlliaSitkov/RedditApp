//
//  PostView.swift
//  RedditApp
//
//  Created by Ілля Сітьков on 01.03.2023.
//

import UIKit

//@IBDesignable
final class PostView: UIView {
    
    let kCONTENT_XIB_NAME = "PostView"
    
    @IBOutlet private weak var contentView: UIView!
    
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var authorLabel: UILabel!
    @IBOutlet private weak var commentsBtn: UIButton!
    @IBOutlet private weak var likesLabel: UILabel!
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var bookmarkBtn: UIButton!
    @IBOutlet private weak var upvotesImg: UIImageView!
    
    let bookmarkSet = UIImage(systemName: "bookmark.circle.fill") ?? UIImage(systemName: "bookmark.fill")
    let bookmarkUnset = UIImage(systemName: "bookmark.circle") ?? UIImage(systemName: "bookmark")
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    func commonInit() {
        Bundle.main.loadNibNamed(kCONTENT_XIB_NAME, owner: self, options: nil)
        contentView.fixInView(self)
        commentsBtn.setImage(UIImage(systemName: "plus.message"), for: .normal)
        upvotesImg.image = UIImage(systemName: "arrow.up.heart")
    }
    
    func clear() {
        self.imageView.image = nil
    }
    
    func config(with post: Post) {
        self.titleLabel.text = post.title
        let time = self.convert(time: Date().timeIntervalSince1970 - Double(post.created))
        let domain = post.domain
        self.authorLabel.text = "\(post.username) • \(time) • \(domain)"
        self.likesLabel.text = String(post.ups - post.downs)
        self.commentsBtn.setTitle(String(post.numComments), for: .normal)
        var imageUrl = ""
        if let preview = post.preview,
               preview.images.count > 0
        {
            let image = preview.images[0]
            imageUrl = (image.resolutions.last {$0.width < 300})?.url ?? image.source.url
        } else {
            imageUrl =  post.thumbnail
        }
        self.imageView.sd_setImage(with: URL(string:imageUrl.replacingOccurrences(of: "amp;", with: "")), placeholderImage: nil)
        self.bookmarkBtn.setImage(post.saved ? self.bookmarkSet : self.bookmarkUnset, for: .normal)
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

extension UIView
{
    func fixInView(_ container: UIView!) -> Void{
        self.translatesAutoresizingMaskIntoConstraints = false;
        self.frame = container.frame;
        container.addSubview(self);
        NSLayoutConstraint(item: self, attribute: .leading, relatedBy: .equal, toItem: container, attribute: .leading, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: self, attribute: .trailing, relatedBy: .equal, toItem: container, attribute: .trailing, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: self, attribute: .top, relatedBy: .equal, toItem: container, attribute: .top, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: .equal, toItem: container, attribute: .bottom, multiplier: 1.0, constant: 0).isActive = true
    }
}
