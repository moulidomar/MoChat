//
//  ViewController.swift
//  MoChat
//
//  Created by Mo Omar on 10/17/17.
//  Copyright © 2017 Moomar. All rights reserved.
//

import UIKit
import Firebase

class ViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Log out", style: .plain, target: self, action: #selector(handleLogin))
        
        // user is not logged in
        if Auth.auth().currentUser?.uid == nil {
            perform(#selector(handleLogin), with: nil, afterDelay: 0)
        }
    }
    
    
    @objc func handleLogin() {
        do {
            try Auth.auth().signOut()
        } catch let logoutError {
            print(logoutError)
        }
        
        
        let login = LoginController()
        present(login, animated: true, completion: nil)
    }

}

