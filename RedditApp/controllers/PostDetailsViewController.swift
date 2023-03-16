//
//  PostDetailsViewController.swift
//  RedditApp
//
//  Created by Ілля Сітьков on 02.03.2023.
//

import Foundation
import UIKit

final class PostDetailsViewController: UIViewController {
    
    @IBOutlet private weak var postView: PostView!
    
    private let stateManager = StateManager.instance
    
    func config(with data: Post) {
        _ = self.view
        self.postView.config(with: data)
        self.postView.delegate = self
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
    
    func imageViewDoubleTapped(post: Post) {
        print("Post details: image double tapped")
    }
}
