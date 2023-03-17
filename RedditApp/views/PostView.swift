//
//  PostView.swift
//  RedditApp
//
//  Created by Ілля Сітьков on 01.03.2023.
//

import UIKit
import SDWebImage

protocol PostViewDelegate: AnyObject {
    func shareButtonClicked(url: URL)
    func saveButtonClicked(id: String, saved: Bool)
}

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
    @IBOutlet private weak var saveView: UIView!
    
    private let bookmarkSet = UIImage(systemName: "bookmark.circle.fill") ?? UIImage(systemName: "bookmark.fill")
    private let bookmarkUnset = UIImage(systemName: "bookmark.circle") ?? UIImage(systemName: "bookmark")
    
    private var post: Post?
    weak var delegate: PostViewDelegate?
    
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
        addGestureRecognizers()
    }
    
    private func addGestureRecognizers() {
        let doubleTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageViewDoubleTapped))
        doubleTapGestureRecognizer.numberOfTapsRequired = 2
        
        self.imageView.addGestureRecognizer(doubleTapGestureRecognizer)
    }
    
    @objc
    func imageViewDoubleTapped(_ sender: UITapGestureRecognizer) {
        animateBookmark()
        if !(self.post?.saved ?? true) {
            updatePost(saved: true)
        }
    }
    
    private func animateBookmark() {
        self.saveView.isHidden = false
        drawBookmark()
        performAnimation()
    }
    
    func resetDefaultImage() {
        self.imageView.image = UIImage(systemName: "photo")
    }
    
    @IBAction func shareButtonClicked(_ sender: UIButton) {
        guard let post = self.post,
              let delegate = self.delegate,
              let url = URL(string: post.url)
        else {return}
        delegate.shareButtonClicked(url: url)
    }
    
    @IBAction func saveButtonClicked() {
        updatePost(saved: !(self.post?.saved ?? false))
    }
    
    private func updatePost(saved: Bool) {
        guard let delegate = delegate,
              let post = self.post
        else {return}
        self.post?.saved = saved
        let image = saved ? self.bookmarkSet : self.bookmarkUnset
        self.bookmarkBtn.setImage(image, for: .normal)
        delegate.saveButtonClicked(id: post.id, saved: saved)
    }
    
    func config(with post: Post) {
        self.post = post
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
            self.imageView.sd_setImage(with: URL(string:imageUrl.replacingOccurrences(of: "amp;", with: "")), placeholderImage: nil)
        }
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
    
    private func drawBookmark() {
        let frame = self.imageView.frame
        
        let midX = frame.midX
        let midY = frame.midY - frame.origin.y
        
        let height = 100.0
        let width = 70.0
        let triangleHeight = 30.0
        
        let path = UIBezierPath()
        
        path.move(to: CGPoint(x: midX-width/2, y: midY-height/2))
        path.addLine(to: CGPoint(x: midX+width/2, y: midY-height/2))
        path.addLine(to: CGPoint(x: midX+width/2, y: midY+height/2))
        path.addLine(to: CGPoint(x: midX, y: midY+height/2-triangleHeight))
        path.addLine(to: CGPoint(x: midX-width/2, y: midY+height/2))
        path.addLine(to: CGPoint(x: midX-width/2, y: midY-height/2))
        path.close()
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        shapeLayer.fillColor = UIColor.link.cgColor

        self.saveView.layer.sublayers?.forEach {$0.removeFromSuperlayer()}
        self.saveView.layer.addSublayer(shapeLayer)
    }
    
    private func performAnimation() {
        self.saveView.transform = CGAffineTransform(scaleX: 0, y: 0)
        UIView.animate(withDuration: 0.7,
                       delay: 0,
                       usingSpringWithDamping: 0.5,
                       initialSpringVelocity: 2,
                       animations: { [weak self] in
            self?.saveView.transform = CGAffineTransform(scaleX: 1, y: 1)
        }) { [weak self] (_) in
            UIView.animate(withDuration: 0.3,
                           animations: { [weak self] in
                self?.saveView.transform = CGAffineTransform(scaleX: 0.000001, y: 0.000001)
            })
        }
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
