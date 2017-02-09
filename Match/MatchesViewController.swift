//
//  MatchesViewController.swift
//  Match
//
//  Created by Chandan Brown on 1/30/17.
//  Copyright © 2017 Chandan B. All rights reserved.
//

import UIKit
import Firebase

fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
    switch (lhs, rhs) {
    case let (l?, r?):
        return l < r
    case (nil, _?):
        return true
    default:
        return false
    }
}

fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
    switch (lhs, rhs) {
    case let (l?, r?):
        return l > r
    default:
        return rhs < lhs
    }
}


class MatchesTableViewController: UIViewController, UISearchControllerDelegate, UITableViewDataSource, UITableViewDelegate {
    
    // Index
    var cellIndexPath: IndexPath!
    var location = CGPoint.zero
    var tableView: UITableView!
    
    
    // Search
    let searchController = UISearchController(searchResultsController: nil)
    lazy var searchBar : UISearchBar = UISearchBar()
    var searchActive   : Bool = false
    
    // Instance
    var chatLogController : ChatLogController?
    
    // Data to go in cells
    var messagesDictionary = [String: Message]()
    var messages = [Message]()
    var filtered = [User]()
    var currentUser: User?
    let cellId = "cellId"
    var users  = [User]()
    var timer  : Timer?
    
    let topView: UIView = {
        let view = UIView()
        // UIColor(red: 0, green: 0, blue: 0, alpha: 0.3)
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let matchesView: UIView = {
        let view = UIView()
        // UIColor(red: 0, green: 0, blue: 0, alpha: 0.3)
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var matchesTextLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.tintColor = .white
        label.text = "Matches"
        label.textColor = .black
        label.textAlignment = .center
        label.font = UIFont(name: "HelveticaNeue-UltraLight", size: 40)
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        topView.addSubview(matchesTextLabel)
        tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .white
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchResultsUpdater = self
        searchController.delegate = self
        
        //tableView.tableHeaderView = searchController.searchBar
        definesPresentationContext = true
        
        searchController.searchBar.tintColor = .white
        searchController.searchBar.searchBarStyle = UISearchBarStyle.prominent
        searchController.searchBar.placeholder = "Search"
        searchController.searchBar.barTintColor = .white
        searchController.searchBar.isTranslucent = false
        searchController.searchBar.delegate = self
        searchController.searchBar.sizeToFit()
        searchController.hidesNavigationBarDuringPresentation = false

        fetchUser()
        observeUserMessages()
        
        tableView.register(UserCell.self, forCellReuseIdentifier: cellId)
        tableView.allowsMultipleSelectionDuringEditing = true
        
        if let splitViewController = splitViewController {
            let controllers = splitViewController.viewControllers
            chatLogController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? ChatLogController
        }
        setupTopAndBottomViews()
        
        
    }
    
    func setupTopAndBottomViews(){
        view.addSubview(topView)
        view.addSubview(tableView)
        view.addSubview(matchesView)
        view.sendSubview(toBack: tableView)
        
        topView.topAnchor.constraint(equalTo: view.topAnchor, constant: 20).isActive = true
        topView.heightAnchor.constraint(equalToConstant: 44).isActive = true
        topView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        
        matchesView.topAnchor.constraint(equalTo: topView.bottomAnchor).isActive = true
        matchesView.heightAnchor.constraint(equalToConstant: 80).isActive = true
        matchesView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        
        tableView.widthAnchor.constraint(equalToConstant: self.view.frame.size.width).isActive = true
        tableView.heightAnchor.constraint(equalToConstant: self.view.frame.size.height).isActive = true
     //   tableView.topAnchor.constraint(equalTo: topView.bottomAnchor).isActive = true
        
        tableView.topAnchor.constraint(equalTo: matchesView.bottomAnchor).isActive = true
        
        matchesTextLabel.centerXAnchor.constraint(equalTo: topView.centerXAnchor).isActive = true
        matchesTextLabel.centerYAnchor.constraint(equalTo: topView.centerYAnchor).isActive = true
        matchesTextLabel.heightAnchor.constraint(equalToConstant: 42).isActive = true
        matchesTextLabel.widthAnchor.constraint(equalTo: topView.widthAnchor).isActive = true
    }
    
    fileprivate func fetchMessageWithMessageId(_ messageId: String) {
        let messagesReference = FIRDatabase.database().reference().child("messages").child(messageId)
        messagesReference.observeSingleEvent(of: .value, with: { (snapshot) in
            
            if let dictionary = snapshot.value as? [String: AnyObject] {
                let message = Message(dictionary: dictionary)
                
                if let chatPartnerId = message.chatPartnerId() {
                    self.messagesDictionary[chatPartnerId] = message
                }
                self.attemptReloadOfTable()
            }
        }, withCancel: nil)
    }
    
    fileprivate func attemptReloadOfTable() {
        self.timer?.invalidate()
        self.timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.handleReloadTable), userInfo: nil, repeats: false)
    }
    
    func observeUserMessages() {
        guard let uid = FIRAuth.auth()?.currentUser?.uid else {
            return
        }
        
        let ref = FIRDatabase.database().reference().child("user-messages").child(uid)
        ref.observe(.childAdded, with: { (snapshot) in
            
            let userId = snapshot.key
            FIRDatabase.database().reference().child("user-messages").child(uid).child(userId).observe(.childAdded, with: { (snapshot) in
                
                let messageId = snapshot.key
                self.fetchMessageWithMessageId(messageId)
                
            }, withCancel: nil)
            
        }, withCancel: nil)
        
        ref.observe(.childRemoved, with: { (snapshot) in
            print(snapshot.key)
            
            self.messagesDictionary.removeValue(forKey: snapshot.key)
            self.attemptReloadOfTable()
            
        }, withCancel: nil)
        
    }
    
    func fetchUser() {
        FIRDatabase.database().reference().child("users").observe(.childAdded, with: { (snapshot) in
            
            if let dictionary = snapshot.value as? [String: AnyObject] {
                let user = User()
                user.id = snapshot.key
                
                user.setValuesForKeys(dictionary)
                self.users.append(user)
                
                DispatchQueue.main.async(execute: {
                    self.tableView.reloadData()
                })
            }
        }, withCancel: nil)
    }
    
    func handleReloadTable() {
        self.messages = Array(self.messagesDictionary.values)
        self.messages.sort(by: { (message1, message2) -> Bool in
            return message1.timestamp?.int32Value > message2.timestamp?.int32Value
        })
        
        DispatchQueue.main.async(execute: {
            self.tableView.reloadData()
        })
    }
    
    func showChatControllerForUser(_ user: User, _ currentUser: User) {
        let chatLogController = ChatLogController(collectionViewLayout: UICollectionViewFlowLayout())
        chatLogController.user = user
        navigationController?.pushViewController(chatLogController, animated: true)
    }
    
    func filterContentForSearchText(searchText: String, scope: String = "All") {
        filtered = users.filter({( user : User) -> Bool in
            let categoryMatch = (scope == "All") || (user.name == scope)
            return categoryMatch && (user.name?.lowercased().contains(searchText.lowercased()))!
        })
        self.attemptReloadOfTable()
    }
    
    func handleCancel() {
        dismiss(animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! UserCell
        
        var user: User
        
        if searchController.isActive && searchController.searchBar.text != "" {
            user = filtered[(indexPath as NSIndexPath).row]
            cell.textLabel?.text = user.name
            cell.timeLabel.text = ""
            if let profileImageUrl = user.profileImageUrl {
                cell.profileImageView.loadImageUsingCacheWithUrlString(profileImageUrl)
            }
            cell.message = nil
            
        } else {
            let message = messages[(indexPath as NSIndexPath).row]
            cell.message = message
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if searchController.isActive && searchController.searchBar.text != ""  {
            var user: User
            
            user = self.filtered[(indexPath as NSIndexPath).row]
            self.showChatControllerForUser(user, self.currentUser!)
            
        } else {
            let message = messages[(indexPath as NSIndexPath).row]
            
            guard let chatPartnerId = message.chatPartnerId() else {
                return
            }
            
            let ref = FIRDatabase.database().reference().child("users").child(chatPartnerId)
            ref.observeSingleEvent(of: .value, with: { (snapshot) in
                guard let dictionary = snapshot.value as? [String: AnyObject] else {
                    return
                }
                
                let user = User()
                user.id = chatPartnerId
                user.setValuesForKeys(dictionary)
                self.showChatControllerForUser(user, self.currentUser!)
                
            }, withCancel: nil)
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let user: User
                if searchController.isActive && searchController.searchBar.text != "" {
                    user = filtered[(indexPath as NSIndexPath).row]
                } else {
                    user = users[(indexPath as NSIndexPath).row]
                }
                let controller = (segue.destination as! UINavigationController).topViewController as! ChatLogController
                controller.user = user
                controller.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
                controller.navigationItem.leftItemsSupplementBackButton = true
            }
        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.isActive && searchController.searchBar.text != ""  {
            return filtered.count
        } else {
            return messages.count
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 72
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        guard let uid = FIRAuth.auth()?.currentUser?.uid else {
            return
        }
        
        let message = self.messages[(indexPath as NSIndexPath).row]
        if let chatPartnerId = message.chatPartnerId() {
            FIRDatabase.database().reference().child("user-messages").child(uid).child(chatPartnerId).removeValue(completionBlock: { (error, ref) in
                
                if error != nil {
                    print("Failed to delete message:", error as Any)
                    return
                }
                
                self.messagesDictionary.removeValue(forKey: chatPartnerId)
                self.attemptReloadOfTable()
            })
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if searchController.isActive {
            return false
        } else {
            return true
        }
    }
}


extension MatchesTableViewController: UISearchBarDelegate {
    // MARK: - UISearchBar Delegate
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        filterContentForSearchText(searchText: searchBar.text!, scope: searchBar.scopeButtonTitles![selectedScope])
        self.attemptReloadOfTable()
    }
}

extension MatchesTableViewController: UISearchResultsUpdating {
    // MARK: - UISearchResultsUpdating Delegate
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        searchBar.placeholder = "Search For Friends"
        // let scope = searchBar.scopeButtonTitles![searchBar.selectedScopeButtonIndex]
        filterContentForSearchText(searchText: searchController.searchBar.text!)
    }
}

class MatchesViewController: UIViewController {
    
    var viewController = MatchesTableViewController()
    
    let messageImageIcon: UIImageView = {
        let imageView = UIImageView()
        let image = UIImage(named: "Messages Image Shape")
        imageView.image = image
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
        view.addSubview(topView)
        view.addSubview(messageImageIcon)
        
        viewController.view.topAnchor.constraint(equalTo: view.topAnchor, constant: 64).isActive = true
        viewController.view.heightAnchor.constraint(equalTo: view.heightAnchor, constant: -34).isActive = true
        viewController.view.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        
        topView.topAnchor.constraint(equalTo: view.topAnchor, constant: 20).isActive = true
        topView.heightAnchor.constraint(equalToConstant: 44).isActive = true
        topView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        
        messageImageIcon.centerXAnchor.constraint(equalTo: topView.centerXAnchor).isActive = true
        messageImageIcon.centerYAnchor.constraint(equalTo: topView.centerYAnchor).isActive = true
        messageImageIcon.heightAnchor.constraint(equalToConstant: 30).isActive = true
        messageImageIcon.widthAnchor.constraint(equalToConstant: 30).isActive = true
    }
}



