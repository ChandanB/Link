//
//  RedViewController.swift
//  Match
//
//  Created by Chandan Brown on 1/30/17.
//  Copyright © 2017 Chandan B. All rights reserved.
//

import UIKit
import Firebase
import FBSDKCoreKit

class ProfileController: UIViewController, UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    func handleLogout() {
        do {
            try FIRAuth.auth()?.signOut()
        } catch let logoutError {
            print(logoutError)
        }
        
        let viewController = ViewController()
        viewController.snapController = SnapContainerViewController()
        let navController = UINavigationController(rootViewController: viewController)
        present(navController, animated: true, completion: nil)
    }
    
    lazy var interestButton: UIButton = {
        let button = UIButton(type: .system)
        button.addTarget(self, action: #selector(handleLogout), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(UIColor.white, for: .normal)
        button.setTitle("", for: .normal)
        button.titleLabel?.font = UIFont(name: "Helvetica-BoldOblique", size: 16)
        button.backgroundColor = .clear
        button.layer.cornerRadius = 12.5
        button.layer.borderWidth = 1.5
        button.layer.borderColor = UIColor.white.cgColor
        return button
    }()
    
    lazy var profileImageView: UIImageView = {
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 130, height: 130))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.isUserInteractionEnabled = true
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = (imageView.frame.size.height/2)
        imageView.layer.borderColor = UIColor.white.cgColor
        imageView.layer.borderWidth = 2
        imageView.clipsToBounds = true
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    lazy var imageViewBackground: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = UIViewContentMode.scaleAspectFill
        imageView.clipsToBounds = true
        imageView.addBlurEffect()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        return imageView
    }()
    
    lazy var usernameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.tintColor = .white
        label.text = self.user.name
        label.textColor = .white
        label.textAlignment = .center
        label.font = UIFont(name: "HelveticaNeue", size: 30)
        return label
    }()
    
    lazy var bioLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = ""
        label.layer.masksToBounds = true
        label.textAlignment = .center
        label.textColor = .white
        label.font = UIFont(name: "Helvetica-Light", size: 16)
        label.numberOfLines = 2
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        return label
    }()
    
    lazy var locationLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = ""
        label.layer.masksToBounds = true
        label.textAlignment = .center
        label.textColor = .white
        label.font = UIFont(name: "Helvetica-LightOblique", size: 16)
        return label
    }()
    
    let editButtonText: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Edit", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont(name: "Helvetica-Light", size: 30)
        return button
    }()
    
    var bioLabelHeightAnchor: NSLayoutConstraint?
    var url: String?
    var user = User()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        FIRAuth.auth()?.addStateDidChangeListener { auth, user in
            if FIRAuth.auth()?.currentUser != nil {
                guard let uid = FIRAuth.auth()?.currentUser?.uid else {
                    return
                }
                
                FIRDatabase.database().reference().child("users").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
                    if let dictionary = snapshot.value as? [String: AnyObject] {
                        self.user.setValuesForKeys(dictionary)
                        self.setupUser()
                    }
                }, withCancel: nil)
            }
        }
    }
    
    func setupUser() {
        
        let screenSize = UIScreen.main.bounds
        let screenWidth = screenSize.width
        let screenHeight = screenSize.height
        self.imageViewBackground = UIImageView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight))
        
        self.view.addSubview((self.imageViewBackground))
        self.view.addSubview(self.usernameLabel)
        self.view.addSubview(self.bioLabel)
        self.view.addSubview(self.locationLabel)
        self.view.addSubview(self.interestButton)
        self.view.addSubview(self.profileImageView)
        self.view.addSubview(self.editButtonText)
        self.view.sendSubview(toBack: (self.imageViewBackground))
        self.setupUsernameLabel()
        self.setupBioLabel()
        self.setupInterestButton()
        self.setupProfileImageView()
        
        if let profileImageUrl = user.profileImageUrl {
            self.profileImageView.loadImageUsingCacheWithUrlString(profileImageUrl)
            self.imageViewBackground.loadImageUsingCacheWithUrlString(profileImageUrl)
            self.imageViewBackground.addBlurEffect()
        }
    }
    
    func setupBioLabel() {
        // x, y, width, height
        bioLabelHeightAnchor = bioLabel.heightAnchor.constraint(equalToConstant: 40)
        bioLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -30).isActive = true
        bioLabel.widthAnchor.constraint(equalTo:   view.widthAnchor, constant: -64).isActive = true
        bioLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        bioLabelHeightAnchor?.isActive = true
        
        locationLabel.heightAnchor.constraint(equalToConstant: 21)
        locationLabel.topAnchor.constraint(equalTo: bioLabel.bottomAnchor, constant: 12).isActive = true
        locationLabel.widthAnchor.constraint(equalTo: bioLabel.widthAnchor).isActive = true
        locationLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
    
    func setupProfileImageView() {
        // x, y, width, height
        profileImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleSelectProfileImageView)))
        profileImageView.bottomAnchor.constraint(equalTo: usernameLabel.topAnchor, constant: -12).isActive = true
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
        usernameLabel.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        usernameLabel.heightAnchor.constraint(equalToConstant: 31.39).isActive = true
        
        editButtonText.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -34).isActive = true
        editButtonText.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        editButtonText.heightAnchor.constraint(equalToConstant: 40).isActive = true
        editButtonText.widthAnchor.constraint(equalToConstant: 60).isActive = true
    }
}

class ProfileViewController: UIViewController {
    
    var viewController = ProfileController()
    
    let profileImageIcon: UIImageView = {
        let imageView = UIImageView()
        let image = UIImage(named: "Profile Image Shape")
        imageView.image = image
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let backButton: UIButton = {
        let imageView = UIButton(type: .custom)
        let image = UIImage(named: "Back Button")
        imageView.setImage(image, for: .normal)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let settingsButton: UIButton = {
        let imageView = UIButton(type: .custom)
        let image = UIImage(named: "Settings Image Shape")
        imageView.setImage(image, for: .normal)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let topView: UIView = {
        let view = UIView()
        // UIColor(red: 0, green: 0, blue: 0, alpha: 0.3)
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addChildViewController(viewController)
        view.backgroundColor = .clear
        viewController.view.translatesAutoresizingMaskIntoConstraints = false
        viewController.view.setCornerRadius(radius: 18)
        setupViewControllerView()
    }
    
    func setupViewControllerView() {
        view.addSubview(viewController.view)
        let screenSize: CGRect = UIScreen.main.bounds
        print(screenSize.width)
        
        if screenSize.width > 320.0 {
            viewController.view.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 64).isActive = true
            viewController.view.heightAnchor.constraint(equalTo: self.view.heightAnchor, constant: -34).isActive = true
            viewController.view.widthAnchor.constraint(equalTo: self.view.widthAnchor, constant: -8).isActive = true
            viewController.view.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 4).isActive = true
            viewController.view.heightAnchor.constraint(equalTo: self.view.heightAnchor, constant: -70).isActive = true
        } else {
            viewController.view.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 64).isActive = true
            viewController.view.heightAnchor.constraint(equalTo: self.view.heightAnchor, constant: -34).isActive = true
            viewController.view.widthAnchor.constraint(equalTo: self.view.widthAnchor, constant: -2).isActive = true
            viewController.view.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 1).isActive = true
            viewController.view.heightAnchor.constraint(equalTo: self.view.heightAnchor, constant: -70).isActive = true
        }
    }
}

















