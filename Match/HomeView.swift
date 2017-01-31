//
//  ViewController.swift
//  Match
//
//  Created by Chandan Brown on 1/30/17.
//  Copyright © 2017 Chandan B. All rights reserved.
//

import UIKit
import EZSwipeController

class HomeViewController: EZSwipeController {
    
    override func setupView() {
        super.setupView()
        datasource = self
        self.automaticallyAdjustsScrollViewInsets = false
        navigationBarShouldBeOnBottom = true
        let navBarColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.3)
        UINavigationBar.appearance().backgroundColor = navBarColor
        view.backgroundColor = .darkGray
    }
}

