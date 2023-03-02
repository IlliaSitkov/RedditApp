//
//  PostCell.swift
//  RedditApp
//
//  Created by Ілля Сітьков on 01.03.2023.
//

import Foundation
import UIKit

final class PostCell: UITableViewCell {
    
    @IBOutlet private weak var postView: PostView!
    
    func config(with data: Post) {
        self.postView.config(with: data)
    }
    
    override func prepareForReuse() {
        self.postView.clear()
    }
    
}








