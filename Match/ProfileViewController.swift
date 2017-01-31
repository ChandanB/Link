//
//  RedViewController.swift
//  Match
//
//  Created by Chandan Brown on 1/30/17.
//  Copyright © 2017 Chandan B. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {

    var homeController: HomeViewController?
    
    func doNothing() {
        
    }
    
    lazy var interestButton: UIButton = {
        let button = UIButton(type: .system)
        button.addTarget(self, action: #selector(doNothing), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(UIColor.white, for: .normal)
        button.setTitle("Singing", for: .normal)
        button.titleLabel?.font = UIFont(name: "Helvetica-BoldOblique", size: 16)
        button.backgroundColor = .clear
        button.layer.cornerRadius = 12.5
        button.layer.borderWidth = 1.5
        button.layer.borderColor = UIColor.white.cgColor
        return button
    }()
    
    lazy var profileImageView: UIImageView = {
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 130, height: 130))
        let origImage = UIImage(named: "Rihanna Image")
      //  let tintedImage = origImage?.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.isUserInteractionEnabled = true
        imageView.backgroundColor = .black
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor   = .white
        imageView.image = origImage
        imageView.layer.cornerRadius = (imageView.frame.size.height/2)
        imageView.layer.borderColor = UIColor.white.cgColor
        imageView.layer.borderWidth = 5
        imageView.clipsToBounds = true
        imageView.layer.masksToBounds = false

        return imageView
    }()

    lazy var usernameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.tintColor = .white
        label.text = "Rihanna"
        label.textColor = .white
        label.textAlignment = .center
        label.font = UIFont(name: "HelveticaNeue", size: 30)
        return label
    }()
    
    let bioLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "A Barbadian recording artist, actress, and fashion designer"
        label.layer.masksToBounds = true
        label.textAlignment = .center
        label.textColor = .white
        label.font = UIFont(name: "Helvetica-Light", size: 16)
        label.numberOfLines = 2
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        return label
    }()
    
    let locationLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Saint Michael, Barbados"
        label.layer.masksToBounds = true
        label.textAlignment = .center
        label.textColor = .white
        label.font = UIFont(name: "Helvetica-LightOblique", size: 16)
        return label
    }()

    var bioLabelHeightAnchor: NSLayoutConstraint?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let screenSize = UIScreen.main.bounds
        let screenWidth = screenSize.width
        let screenHeight = screenSize.height
        let imageViewBackground = UIImageView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight))
        imageViewBackground.image = UIImage(named: "Rihanna Image")
        imageViewBackground.contentMode = UIViewContentMode.scaleAspectFill
        imageViewBackground.clipsToBounds = true
        imageViewBackground.addBlurEffect()
        
        view.addSubview(imageViewBackground)
        view.addSubview(usernameLabel)
        view.addSubview(bioLabel)
        view.addSubview(locationLabel)
        view.addSubview(interestButton)
        view.addSubview(profileImageView)
        view.sendSubview(toBack: imageViewBackground)
        setupUsernameLabel()
        setupBioLabel()
        setupInterestButton()
        setupProfileImageView()
    }
    
    func setupBioLabel() {
        // x, y, width, height
        bioLabelHeightAnchor = bioLabel.heightAnchor.constraint(equalToConstant: 42)
        bioLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        bioLabel.widthAnchor.constraint(equalTo:   view.widthAnchor, constant: -34).isActive = true
        bioLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        bioLabelHeightAnchor?.isActive = true
        
        locationLabel.heightAnchor.constraint(equalToConstant: 21)
        locationLabel.topAnchor.constraint(equalTo: bioLabel.bottomAnchor, constant: 12).isActive = true
        locationLabel.widthAnchor.constraint(equalTo: bioLabel.widthAnchor).isActive = true

        locationLabel.widthAnchor.constraint(equalTo:   view.widthAnchor, constant: -64).isActive = true
        locationLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
    
    func setupProfileImageView() {
        // x, y, width, height
        profileImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(doNothing)))
        profileImageView.bottomAnchor.constraint(equalTo: usernameLabel.topAnchor, constant: -12).isActive = true
        profileImageView.topAnchor.constraint(equalTo: usernameLabel.bottomAnchor, constant: 12).isActive = true
        profileImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 130).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 130).isActive = true
    }
    
    func setupInterestButton() {
        //need x, y, width, height constraints
        interestButton.topAnchor.constraint(equalTo: locationLabel.bottomAnchor, constant: 24).isActive = true
        interestButton.widthAnchor.constraint(equalToConstant: 93).isActive = true
        interestButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        interestButton.heightAnchor.constraint(equalToConstant: 25).isActive = true
    }
    
    func setupUsernameLabel() {
        // x, y, width, height
        usernameLabel.bottomAnchor.constraint(equalTo: bioLabel.topAnchor, constant: -4).isActive = true
        usernameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        usernameLabel.widthAnchor.constraint(equalToConstant: 216).isActive = true
        usernameLabel.heightAnchor.constraint(equalToConstant: 31.39).isActive = true
    }
}
