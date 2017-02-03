//
//  SearchViewController.swift
//  Match
//
//  Created by Chandan Brown on 1/30/17.
//  Copyright © 2017 Chandan B. All rights reserved.
//

import UIKit
import CoreImage
import NVActivityIndicatorView

class SearchViewController: UIViewController, NVActivityIndicatorViewable {
    var context = CIContext(options: nil)
    var loading: NVActivityIndicatorView?
    var searching: SearchingEnum?
    
    lazy var loadingView: NVActivityIndicatorView = {
        let load = NVActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        return load
    }()
    
    lazy var searchLabel: UILabel = {
        let label = UILabel()
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(startSearching))
        label.addGestureRecognizer(tap)
        label.isUserInteractionEnabled = true
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Begin Search"
        label.textColor = .white
        label.textAlignment = .center
        label.font = UIFont(name: "HelveticaNeue-Medium", size: 42)
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searching = SearchingEnum.notSearching
        self.loading = NVActivityIndicatorView(frame: CGRect(x: self.view.frame.midX - 50, y: self.view.frame.midY - 60, width: 100, height: 100), type: NVActivityIndicatorType.lineScalePulseOut, color: .white, padding: NVActivityIndicatorView.DEFAULT_PADDING)
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
        view.addSubview(searchLabel)
        view.addSubview((self.loading)!)
        setupSearchLabel()
    }
    
    func startSearching() {
        if searching == .notSearching {
            searching = .isSearching
            UIView.transition(with: searchLabel, duration: 0.2, options: [.transitionCrossDissolve], animations: {
                self.setupCancelLabel()
                self.searchLabel.text = "Cancel"
                self.searchLabel.textColor = .red
                self.searchLabel.font = UIFont(name: "HelveticaNeue-UltraLight", size: 42)
                self.loading?.startAnimating()
            }, completion:nil)
            
        } else if self.searchLabel.text == "Cancel" {
            self.setupSearchLabel()
            searching = .notSearching
            self.loading?.stopAnimating()
            UIView.transition(with: searchLabel, duration: 0.2, options: [.transitionCrossDissolve], animations: {
                self.searchLabel.text = "Begin Search"
                self.searchLabel.textColor = .white
                self.searchLabel.font = UIFont(name: "HelveticaNeue-Medium", size: 42)
            }, completion:nil)
        }
    }
    
    func setupCancelLabel(){
        self.view.layoutIfNeeded()
        UIView.animate(withDuration: 0.25, animations: {
            self.searchLabelBottomAnchor?.constant = 310
            self.view.layoutIfNeeded()
        })
    }
    
    var searchLabelBottomAnchor: NSLayoutConstraint?
    
    func setupSearchLabel() {
        // x, y, width, height
        self.view.layoutIfNeeded()
        UIView.animate(withDuration: 1, animations: {
            self.searchLabelBottomAnchor = self.searchLabel.bottomAnchor.constraint(equalTo: (self.loading?.topAnchor)!, constant: -10)
            self.searchLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
            self.searchLabel.widthAnchor.constraint(equalToConstant: 316).isActive = true
            self.searchLabel.heightAnchor.constraint(equalToConstant: 61.39).isActive = true
            self.searchLabelBottomAnchor?.isActive = true
            self.view.layoutIfNeeded()
        })
    }
    
}
