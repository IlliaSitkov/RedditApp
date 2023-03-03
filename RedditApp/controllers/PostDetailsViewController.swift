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
    }
    
}
