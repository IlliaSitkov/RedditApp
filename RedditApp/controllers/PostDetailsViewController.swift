//
//  PostDetailsViewController.swift
//  RedditApp
//
//  Created by Ілля Сітьков on 02.03.2023.
//

import Foundation
import UIKit
import SwiftUI

final class PostDetailsViewController: UIViewController {
    
    @IBOutlet private weak var postView: PostView!
    @IBOutlet private weak var containerView: UIView!
    
    private let stateManager = StateManager.instance
    private var post: Post?
    
    func config(with data: Post) {
        _ = self.view
        self.post = data
        self.postView.config(with: data)
        self.postView.delegate = self
        addCommentsSection(forPost: data)
    }
    
    private func openCommentDetail(comment: Comment) {
        let controller = UIHostingController(rootView: CommentDetail(comment: comment))
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    
    private func addCommentsSection(forPost post: Post) {
        let controller = UIHostingController(
            rootView: CommentList(subreddit: Const.SUBREDDIT, postId: post.id, handleTap: self.openCommentDetail)
        )
        
        let swiftUIView: UIView = controller.view
        self.containerView.addSubview(swiftUIView)
        
        swiftUIView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            swiftUIView.topAnchor.constraint(equalTo: self.containerView.topAnchor),
            swiftUIView.trailingAnchor.constraint(equalTo: self.containerView.trailingAnchor),
            swiftUIView.bottomAnchor.constraint(equalTo: self.containerView.bottomAnchor),
            swiftUIView.leadingAnchor.constraint(equalTo: self.containerView.leadingAnchor)
        ])
        
        controller.didMove(toParent: self)
    }
    
    
}

//MARK: - PostViewDelegate
extension PostDetailsViewController: PostViewDelegate {
    
    func shareButtonClicked(url: URL) {
        let ac = UIActivityViewController(activityItems: [url], applicationActivities: nil)
        present(ac, animated: true)
    }
    
    func saveButtonClicked(id: String, saved: Bool) {
        if saved {
            self.stateManager.handle(action: .savePost(id: id))
        } else {
            self.stateManager.handle(action: .unsavePost(id: id))
        }
    }
}
