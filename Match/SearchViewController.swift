//
//  SearchViewController.swift
//  Match
//
//  Created by Chandan Brown on 1/30/17.
//  Copyright © 2017 Chandan B. All rights reserved.
//

import UIKit
import CoreImage

class SearchViewController: UIViewController {
    var context = CIContext(options: nil)
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        let screenSize = UIScreen.main.bounds
        let screenWidth = screenSize.width
        let screenHeight = screenSize.height
        let imageViewBackground = UIImageView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight))
        let image = UIImage(named: "Rihanna Image")
        imageViewBackground.image = image
        imageViewBackground.contentMode = UIViewContentMode.scaleAspectFill
        imageViewBackground.clipsToBounds = true
        let currentFilter = CIFilter(name: "CIPhotoEffectNoir")
        currentFilter!.setValue(CIImage(image: imageViewBackground.image!), forKey: kCIInputImageKey)
        let output = currentFilter!.outputImage
        let cgimg = context.createCGImage(output!,from: output!.extent)
        let processedImage = UIImage(cgImage: cgimg!)
        imageViewBackground.image = processedImage
        imageViewBackground.addBlurEffect()
        view.sendSubview(toBack: imageViewBackground)
        view.addSubview(imageViewBackground)
       // view.addSubview(searchLabel)
       // view.addSubview(startSearchImageView)
        view.sendSubview(toBack: imageViewBackground)
        //setupUsernameLabel()
       // setupProfileImageView()

        view.addSubview(imageViewBackground)
    }

    lazy var startSearchImageView: UIImageView = {
        let imageView = UIImageView()
        let origImage = UIImage(named: "Go Image")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.isUserInteractionEnabled = true
        imageView.image = origImage
        imageView.clipsToBounds = true
        imageView.layer.masksToBounds = false
        
        return imageView
    }()
    
    lazy var searchLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.tintColor = .white
        label.text = "Begin Search"
        label.textColor = .white
        label.textAlignment = .center
        label.font = UIFont(name: "HelveticaNeue", size: 46)
        return label
    }()
    var searchHeightAnchor: NSLayoutConstraint?

    
    func setupProfileImageView() {
        // x, y, width, height
        startSearchImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        startSearchImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        searchHeightAnchor = startSearchImageView.heightAnchor.constraint(equalToConstant: 500)
        startSearchImageView.widthAnchor.constraint(equalToConstant: 590).isActive = true
        searchHeightAnchor?.isActive = true
    }
    
    func setupUsernameLabel() {
//        // x, y, width, height
        searchLabel.bottomAnchor.constraint(equalTo: startSearchImageView.topAnchor, constant: -6).isActive = true
       searchLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        searchLabel.widthAnchor.constraint(equalToConstant: 216).isActive = true
        searchLabel.heightAnchor.constraint(equalToConstant: 31.39).isActive = true
    }

}
