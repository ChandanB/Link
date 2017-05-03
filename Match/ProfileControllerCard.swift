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

class ProfileControllerCard: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var startingFrame: CGRect?
    var blackBackgroundView: UIView?
    var startingImageView: UIImageView?
    
    var user = User(dictionary: [:])
    
    lazy var profileImageView: UIImageView = {
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 90, height: 130))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.isUserInteractionEnabled = true
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = (imageView.frame.size.height/2)
        imageView.layer.borderColor = UIColor.white.cgColor
        imageView.layer.borderWidth = 3
        imageView.clipsToBounds = true
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    var locationImage: UIImageView = {
        let imageView = UIImageView()
        let image = UIImage(named: "Location symbol")
        imageView.image = image
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.isUserInteractionEnabled = true
        imageView.clipsToBounds = true
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    var followersImage: UIImageView = {
        let imageView = UIImageView()
        let image = UIImage(named: "followers")
        imageView.image = image
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.isUserInteractionEnabled = true
        imageView.clipsToBounds = true
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    var starImage: UIImageView = {
        let imageView = UIImageView()
        let image = UIImage(named: "star")
        imageView.image = image
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.isUserInteractionEnabled = true
        imageView.clipsToBounds = true
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    var deckImage: UIImageView = {
        let imageView = UIImageView()
        let image = UIImage(named: "Deck")
        imageView.image = image
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.isUserInteractionEnabled = true
        imageView.clipsToBounds = true
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    var viewImage: UIImageView = {
        let imageView = UIImageView()
        let image = UIImage(named: "View Deck")
        imageView.image = image
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.isUserInteractionEnabled = true
        imageView.clipsToBounds = true
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    lazy var imageViewBackground: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = UIViewContentMode.scaleAspectFill
        imageView.clipsToBounds = true
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
        label.font = UIFont(name: "HelveticaNeue-Medium", size: 24)
        return label
    }()
    
    lazy var socialPointSmallLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.tintColor = .white
        label.text = "Card Type - Newbie"
        label.textColor = .white
        label.textAlignment = .center
        label.font = UIFont(name: "Helvetica-LightOblique", size: 16)
        return label
    }()
    
    lazy var socialPointBigLabel: UILabel = {
        let label = UILabel()
        let rookieBronze = UIColor.rgb(201, green: 144, blue: 91)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Social Rookie"
        label.textColor = rookieBronze
        label.textAlignment = .center
        label.font = UIFont(name: "AmericanTypewriter", size: 40)
        return label
    }()
    
    lazy var followersLabel: UILabel = {
        let label = UILabel()
        let allFollowers = self.user.followersCount! + self.user.friendsCount!
        let asString = String(describing: allFollowers)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.tintColor = .white
        label.text = "\(asString) Followers"
        label.textColor = .white
        label.textAlignment = .center
        label.font = UIFont(name: "Helvetica-LightOblique", size: 16)
        return label
    }()
    
    lazy var bioLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Helvetica-Light", size: 16)
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = self.user.bio
        label.layer.masksToBounds = true
        label.textAlignment = .center
        label.textColor = .white
        return label
    }()
    
    lazy var locationLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = self.user.location
        label.layer.masksToBounds = true
        label.textAlignment = .center
        label.textColor = .white
        label.font = UIFont(name: "Helvetica-LightOblique", size: 16)
        return label
    }()
    
    lazy var settingsButton: UIButton = {
        let button = UIButton(type: .custom)
        let settingsImage = UIImage(named: "Settings Image Shape")
        button.setImage(settingsImage, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector (goToUserProfilePage), for: .touchUpInside)
        return button
    }()
    
    lazy var deckButton: UIButton = {
        let button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector (goToUserDeck), for: .touchUpInside)
        return button
    }()
    
    lazy var deckLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "5 Cards"
        label.layer.masksToBounds = true
        label.textAlignment = .center
        label.textColor = .white
        label.font = UIFont(name: "Helvetica-LightOblique", size: 16)
        return label
    }()
    
    lazy var topView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var bottomView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.4)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let lineView1: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(r: 220, g: 220, b: 220)
        return view
    }()
    
    let lineView2: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(r: 220, g: 220, b: 220)
        return view
    }()
    
    let lineView3: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(r: 220, g: 220, b: 220)
        return view
    }()
    
    let lineView4: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(r: 220, g: 220, b: 220)
        return view
    }()
    
    var bioLabelHeightAnchor: NSLayoutConstraint?
    var url: String?
    
    override func viewDidAppear(_ animated: Bool) {
        fetchUser()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        FIRAuth.auth()?.addStateDidChangeListener { auth, user in
            if FIRAuth.auth()?.currentUser != nil {
                guard let uid = FIRAuth.auth()?.currentUser?.uid else {
                    return
                }
                
                FIRDatabase.database().reference().child("users").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
                    if (snapshot.value as? [String: AnyObject]) != nil {
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
        
        view.addSubview(topView)
        view.addSubview(bottomView)
        view.addSubview(lineView1)
        view.addSubview(lineView2)
        view.addSubview(lineView3)
        view.addSubview(lineView4)
        view.addSubview(followersLabel)
        view.addSubview(socialPointBigLabel)
        view.addSubview(socialPointSmallLabel)
        view.addSubview(deckLabel)
        view.addSubview(viewImage)
        view.addSubview(followersImage)
        view.addSubview(starImage)
        view.addSubview(deckImage)
        view.addSubview((imageViewBackground))
        view.addSubview(bioLabel)
        view.addSubview(locationLabel)
        view.addSubview(profileImageView)
        view.addSubview(usernameLabel)
        view.addSubview(settingsButton)
        view.addSubview(locationImage)
        view.addSubview(deckButton)
        
        view.sendSubview(toBack: imageViewBackground)
        setupProfileImageView()
        setupUsernameLabel()
        setupBioLabel()
        setupLines()
        
        if let profileImageUrl = user.profileImageUrl {
            self.profileImageView.loadImageUsingCacheWithUrlString(profileImageUrl)
            updateImageViewBackground()
        }
        
        self.imageViewBackground.addBlurEffect()
    }
    
    func goToUserProfilePage() {
        print("Button pressed")
        let vc = HomeViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func goToUserDeck() {
       // let vc = DeckViewController(collectionViewLayout: UICollectionViewFlowLayout())
        let vc = ViewController()
       // vc.user = self.user
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func updateImageViewBackground() {
        if let profileImageUrl = user.profileImageUrl {
            self.imageViewBackground.loadImageUsingCacheWithUrlString(profileImageUrl)
            
        }
    }
    
    func setupProfileImageView() {
        
        // x, y, width, height
        topView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        topView.heightAnchor.constraint(equalToConstant: 44).isActive = true
        topView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        topView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        // x, y, width, height
        bottomView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20).isActive = true
        bottomView.heightAnchor.constraint(equalToConstant: 64).isActive = true
        bottomView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        bottomView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        // x, y, width, height
        settingsButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 15).isActive = true
        settingsButton.centerYAnchor.constraint(equalTo: bottomView.centerYAnchor).isActive = true
        settingsButton.heightAnchor.constraint(equalToConstant: 35).isActive = true
        settingsButton.widthAnchor.constraint(equalToConstant: 35).isActive = true
        
        // x, y, width, height
        profileImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(imageTapped)))
        profileImageView.topAnchor.constraint(equalTo: topView.bottomAnchor, constant: 10).isActive = true
        profileImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 130).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 130).isActive = true
        
        
        socialPointBigLabel.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 25).isActive = true
        socialPointBigLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        socialPointBigLabel.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        socialPointBigLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
    }
    
    func setupUsernameLabel() {
        // x, y, width, height
        usernameLabel.bottomAnchor.constraint(equalTo: topView.bottomAnchor, constant: -2).isActive = true
        usernameLabel.centerXAnchor.constraint(equalTo: topView.centerXAnchor).isActive = true
        usernameLabel.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        usernameLabel.heightAnchor.constraint(equalToConstant: 31.39).isActive = true
    }
    
    func setupBioLabel() {
        
        // x, y, width, height
        bioLabel.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 70).isActive = true
        bioLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        bioLabel.heightAnchor.constraint(equalToConstant: 48).isActive = true
        bioLabel.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -10).isActive = true
        
        // x, width, height
        locationLabel.bottomAnchor.constraint(equalTo: lineView1.topAnchor, constant: -3).isActive = true
        locationLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        locationLabel.heightAnchor.constraint(equalToConstant: 18).isActive = true
        locationLabel.widthAnchor.constraint(equalToConstant: 120).isActive = true
        
        locationImage.bottomAnchor.constraint(equalTo: lineView1.topAnchor, constant: -3).isActive = true
        locationImage.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: -130).isActive = true
        locationImage.widthAnchor.constraint(equalToConstant: 15).isActive = true
        locationImage.heightAnchor.constraint(equalToConstant: 20).isActive = true
    }
    
    func setupLines() {
        
        lineView1.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        lineView1.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        lineView1.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        lineView1.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 50).isActive = true
        
        // star
        starImage.bottomAnchor.constraint(equalTo: lineView2.topAnchor, constant: -15).isActive = true
        starImage.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: -130).isActive = true
        starImage.widthAnchor.constraint(equalToConstant: 20).isActive = true
        starImage.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        socialPointSmallLabel.bottomAnchor.constraint(equalTo: lineView2.topAnchor, constant: -15).isActive = true
        socialPointSmallLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        socialPointSmallLabel.widthAnchor.constraint(equalToConstant: 360).isActive = true
        socialPointSmallLabel.heightAnchor.constraint(equalToConstant: 18).isActive = true
        
        lineView2.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        lineView2.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        lineView2.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        lineView2.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 100).isActive = true
        
        // followers
        followersImage.bottomAnchor.constraint(equalTo: lineView3.topAnchor, constant: -15).isActive = true
        followersImage.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: -130).isActive = true
        followersImage.widthAnchor.constraint(equalToConstant: 20).isActive = true
        followersImage.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        followersLabel.bottomAnchor.constraint(equalTo: lineView3.topAnchor, constant: -15).isActive = true
        followersLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        followersLabel.widthAnchor.constraint(equalToConstant: 120).isActive = true
        followersLabel.heightAnchor.constraint(equalToConstant: 18).isActive = true
        
        lineView3.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        lineView3.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        lineView3.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        lineView3.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 150).isActive = true
        
        // deck
        deckImage.bottomAnchor.constraint(equalTo: lineView4.topAnchor, constant: -15).isActive = true
        deckImage.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: -130).isActive = true
        deckImage.widthAnchor.constraint(equalToConstant: 25).isActive = true
        deckImage.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        deckLabel.bottomAnchor.constraint(equalTo: lineView4.topAnchor, constant: -15).isActive = true
        deckLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        deckLabel.widthAnchor.constraint(equalToConstant: 120).isActive = true
        deckLabel.heightAnchor.constraint(equalToConstant: 18).isActive = true
        
        deckButton.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        deckButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        deckButton.bottomAnchor.constraint(equalTo: lineView4.topAnchor).isActive = true
        deckButton.topAnchor.constraint(equalTo: lineView3.bottomAnchor).isActive = true

        viewImage.bottomAnchor.constraint(equalTo: lineView4.topAnchor, constant: -15).isActive = true
        viewImage.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 130).isActive = true
        viewImage.widthAnchor.constraint(equalToConstant: 10).isActive = true
        viewImage.heightAnchor.constraint(equalToConstant: 15).isActive = true
    
        lineView4.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        lineView4.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        lineView4.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        lineView4.bottomAnchor.constraint(equalTo: bottomView.topAnchor).isActive = true
    }
    func fetchUser() {
        guard let uid = FIRAuth.auth()?.currentUser?.uid else {
            //for some reason uid = nil
            return
        }
        
        FIRDatabase.database().reference().child("users").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
            if let dictionary = snapshot.value as? [String: AnyObject] {
                self.user = User(dictionary: dictionary)
                print("user successfully made with dictionary")
            }
        }, withCancel: nil)
    }
}
