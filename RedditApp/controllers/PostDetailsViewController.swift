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
    
    func config(with data: Post) {
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
}
