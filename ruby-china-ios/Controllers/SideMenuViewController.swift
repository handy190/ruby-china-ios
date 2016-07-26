//
//  SideMenuViewController.swift
//  ruby-china-ios
//
//  Created by Jason Lee on 16/7/23.
//  Copyright © 2016年 ruby-china. All rights reserved.
//

import UIKit

class SideMenuViewController: UITableViewController {
    let menuItems = ["讨论区", "优质话题", "最近发布", "招聘"]
    let menuItemIcons = ["topic", "popular", "latest", "jobs"]
    let menuItemPaths = ["/topics", "/topics/popular", "/topics/last", "/jobs"]
    var newButton = UIBarButtonItem()
    var loginButton = UIBarButtonItem()
    var logoutButton = UIBarButtonItem()
    var profileButton = UIBarButtonItem()
    let blankButton = UIBarButtonItem()
    
    deinit {
        OAuth2.shared.removeObserver(self, forKeyPath: "accessToken")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        OAuth2.shared.addObserver(self, forKeyPath: "accessToken", options: .New, context: nil)
        
        title = "Ruby China"
        
        newButton = UIBarButtonItem.init(image: UIImage.init(named: "send"), style: .Plain, target: self, action: #selector(actionNewTopic))
        newButton.tintColor = UIColor.blackColor()
        profileButton = UIBarButtonItem.init(image: UIImage.init(named: "profile"), style: .Plain, target: self, action: #selector(actionProfile))
        profileButton.tintColor = UIColor.blackColor()
        
        loginButton = UIBarButtonItem.init(image: UIImage.init(named: "login"), style: .Plain, target: self, action: #selector(actionLogin))
        loginButton.tintColor = UIColor.blackColor()
        
        logoutButton = UIBarButtonItem.init(image: UIImage.init(named: "logout"), style: .Plain, target: self, action: #selector(actionLogout))
        logoutButton.tintColor = UIColor.blackColor()
        
        
        uploadLoginState()
        
        guard tableView.backgroundView == nil else {
            return
        }
        
        // Set up a cool background image for demo purposes
        let imageView = UIImageView(image: UIImage(named: "Appicon"))
        imageView.contentMode = .ScaleAspectFit
        imageView.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.01)
        tableView.backgroundView = imageView
        
        tableView.delegate = self;
        tableView.dataSource = self;
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuItems.count
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as UITableViewCell
        
        // Configure the cell...
        cell.textLabel!.text = menuItems[indexPath.row]
        cell.imageView?.image = UIImage.init(named: menuItemIcons[indexPath.row])
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let path = menuItemPaths[indexPath.row]
        uploadLoginState()
        actionWithPath(path)
    }
    
    func uploadLoginState() {
        if OAuth2.shared.isLogined {
            self.toolbarItems = [profileButton, logoutButton]
            navigationItem.rightBarButtonItem = newButton
        } else {
            self.toolbarItems = [loginButton]
            navigationItem.rightBarButtonItem = nil
        }
    }
    
    func actionWithPath(path: String) {
        navigationController?.dismissViewControllerAnimated(true, completion: {
            NSNotificationCenter.defaultCenter().postNotificationName("menuClicked", object: self, userInfo: ["path": path])
        })
        
    }
    
    func actionLogout() {
        OAuth2.shared.logout()
        uploadLoginState()
    }
    
    func actionProfile() {
        actionWithPath("/account/edit")
    }
    
    func actionNewTopic() {
        actionWithPath("/topics/new")
    }
    
    func actionLogin() {
        actionWithPath("/account/sign_in")
    }
    
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        if keyPath == "accessToken" {
            uploadLoginState()
        }
    }
    
    
}