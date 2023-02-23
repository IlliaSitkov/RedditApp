//
//  ViewController.swift
//  RedditApp
//
//  Created by Ілля Сітьков on 23.02.2023.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let service = PostService()
        let res = await service.getPostsWithParams(subreddit: "ios", limit: 1)
    }


}

