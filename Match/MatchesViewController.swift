//
//  MatchesViewController.swift
//  Match
//
//  Created by Chandan Brown on 1/30/17.
//  Copyright © 2017 Chandan B. All rights reserved.
//

import UIKit

class MatchesViewController: UIViewController {
    
    lazy var bottomView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.3)
        view.frame = CGRect(x: 0, y: Constants.ScreenHeightWithoutStatusBar - Constants.navigationBarHeight, width: Constants.ScreenWidth, height: Constants.navigationBarHeight)
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.83)
        view.addSubview(bottomView)
    }
}
