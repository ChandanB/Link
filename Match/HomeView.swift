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
        view.backgroundColor = .clear
    }
}

