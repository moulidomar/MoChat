//
//  LoginController.swift
//  MoChat
//
//  Created by Mo Omar on 10/17/17.
//  Copyright © 2017 Moomar. All rights reserved.
//

import UIKit
import Firebase

class LoginController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 100/255, green: 100/255, blue: 220/255, alpha: 1)
        
        
        
        view.addSubview(containerView)
        setupContainer()
        
        view.addSubview(loginRegisterButton)
        setuploginRegisterButton()
        
        view.addSubview(segControl)
        setupSegControl()
        
        view.addSubview(profileImageView)
        setupProfileImageView()
    }
    
    let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "profile pic.png")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleToFill
        return imageView
    }()
    
    let segControl: UISegmentedControl = {
        let sc = UISegmentedControl(items: ["Login", "Register"])
        sc.tintColor = .white
        sc.selectedSegmentIndex = 1
        sc.translatesAutoresizingMaskIntoConstraints = false
        sc.addTarget(self, action: #selector(handleChanges), for: .valueChanged)
        return sc
    }()
    
    
    func handleLoginRegister() {
        if segControl.selectedSegmentIndex == 0 {
            handleLogin()
        }
        else{
            handleRegister()
        }
    }
    
    
    func handleLogin() {
        guard let email = emailTF.text, let password = passwordTF.text else {
            print("Form is not valid")
            return
        }
        
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            if error != nil {
                print(error!)
                return
            }
            //successfully Logged in user
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    
    
    
    
    
    let containerView: UIView = {
        let cv = UIView()
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.backgroundColor = .white
        cv.layer.cornerRadius = 10
        cv.layer.masksToBounds = true
        return cv
    }()
    
    let nameTF: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Name"
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    let nameSeperator: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .lightGray
        return view
    }()
    
    
    let emailTF: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Email"
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    let emailSeperator: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .lightGray
        return view
    }()
    let passwordTF: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Password"
        tf.isSecureTextEntry = true
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    lazy var loginRegisterButton: UIButton = {
        let button = UIButton()
        button.setTitle("Register", for: .normal)
        button.backgroundColor = UIColor(red: 80/255, green: 90/255, blue: 161/255, alpha: 1)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(handleRegister), for: .touchUpInside)
        return button
    }()
    
    @objc func handleRegister() {
        guard let name = nameTF.text, let email = emailTF.text, let password = passwordTF.text else {
            print("Form is not valid")
            return
        }
        
        Auth.auth().createUser(withEmail: email, password: password) { (user: User!, error) in
            if error != nil {
                print(error!)
                return
            }
            guard let uid = user?.uid else {
                return
            }
            
            
            
            // Successfully Authenticated user
            let ref = Database.database().reference(fromURL: "https://mochat-66ab6.firebaseio.com/")
            let userref = ref.child("user").child(uid)
            let values = ["name": name, "email": email]
            userref.updateChildValues(values, withCompletionBlock: { (Error, ref) in
                if Error != nil {
                    print(Error!)
                    return
                }
                self.dismiss(animated: true, completion: nil)
                
                print("Saved user successfully into Firebase Database")
            })
        }
        
    }
    
    var conHight: NSLayoutConstraint?
    var nameHight: NSLayoutConstraint?
    var emailHight: NSLayoutConstraint?
    var nSep: NSLayoutConstraint?
    var passwordHight: NSLayoutConstraint?
    var profileImageHeight: NSLayoutConstraint?
    
    func setupSegControl() {
        segControl.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        segControl.bottomAnchor.constraint(equalTo: containerView.topAnchor, constant: -12).isActive = true
        segControl.widthAnchor.constraint(equalToConstant: 250).isActive = true
        profileImageHeight = segControl.heightAnchor.constraint(equalToConstant: 36)
            profileImageHeight?.isActive = true
    }
   
    
    @objc func handleChanges() {
        let title = segControl.titleForSegment(at: segControl.selectedSegmentIndex)
        loginRegisterButton.setTitle(title, for: .normal)
        
        
        // containerView Changes
        conHight?.constant = segControl.selectedSegmentIndex == 0 ? 100 : 150
        
        // nameTF changes
        nameHight?.isActive = false
        nameHight = nameTF.heightAnchor.constraint(equalTo: containerView.heightAnchor, multiplier: segControl.selectedSegmentIndex == 0 ? 0 : 1/3)
        nameHight?.isActive = true
        
        //nameSeperator changes
        nSep?.constant = segControl.selectedSegmentIndex == 0 ? 0 : 1
        
        // emailTF changes
        emailHight?.isActive = false
        emailHight = emailTF.heightAnchor.constraint(equalTo: containerView.heightAnchor, multiplier: segControl.selectedSegmentIndex == 0 ? 1/2 : 1/3 )
        emailHight?.isActive = true
        
        // passwordTF changes
        passwordHight?.isActive = false
        passwordHight = passwordTF.heightAnchor.constraint(equalTo: containerView.heightAnchor, multiplier: segControl.selectedSegmentIndex == 0 ? 1/2 : 1/3)
        passwordHight?.isActive = true
        
        // profileImageView
        profileImageHeight?.isActive = false
        profileImageHeight = profileImageView.heightAnchor.constraint(equalToConstant: segControl.selectedSegmentIndex == 0 ? 0: 150)
        profileImageHeight?.isActive = true
        
        
    }
    
    func setupProfileImageView() {
        profileImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        profileImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 55).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 120).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 120).isActive = true
    }
    
    
    func setupContainer() {
        view.addSubview(nameTF)
        view.addSubview(nameSeperator)
        view.addSubview(emailTF)
        view.addSubview(emailSeperator)
        view.addSubview(passwordTF)
        
        containerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        containerView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        containerView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -20).isActive = true
        conHight = containerView.heightAnchor.constraint(equalToConstant: 150)
        conHight?.isActive = true
        
        nameTF.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 12).isActive = true
        nameTF.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
        nameTF.widthAnchor.constraint(equalTo: containerView.widthAnchor).isActive = true
        nameHight = nameTF.heightAnchor.constraint(equalTo: containerView.heightAnchor, multiplier: 1/3)
        nameHight?.isActive = true
        
        nameSeperator.leftAnchor.constraint(equalTo: containerView.leftAnchor).isActive = true
        nameSeperator.topAnchor.constraint(equalTo: nameTF.bottomAnchor).isActive = true
        nameSeperator.widthAnchor.constraint(equalTo: containerView.widthAnchor).isActive = true
        nSep = nameSeperator.heightAnchor.constraint(equalToConstant: 1)
        nSep?.isActive = true
        
        emailTF.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 12).isActive = true
        emailTF.topAnchor.constraint(equalTo: nameSeperator.bottomAnchor).isActive = true
        emailTF.widthAnchor.constraint(equalTo: containerView.widthAnchor).isActive = true
        emailHight = emailTF.heightAnchor.constraint(equalTo: containerView.heightAnchor, multiplier: 1/3)
        emailHight?.isActive = true
        
        emailSeperator.leftAnchor.constraint(equalTo: containerView.leftAnchor).isActive = true
        emailSeperator.topAnchor.constraint(equalTo: emailTF.bottomAnchor).isActive = true
        emailSeperator.widthAnchor.constraint(equalTo: containerView.widthAnchor).isActive = true
        emailSeperator.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        passwordTF.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 12).isActive = true
        passwordTF.topAnchor.constraint(equalTo: emailSeperator.bottomAnchor).isActive = true
        passwordTF.widthAnchor.constraint(equalTo: containerView.widthAnchor).isActive = true
        passwordHight = passwordTF.heightAnchor.constraint(equalTo: containerView.heightAnchor, multiplier: 1/3)
        passwordHight?.isActive = true
        
    }
    
    func setuploginRegisterButton() {
        loginRegisterButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loginRegisterButton.topAnchor.constraint(equalTo: containerView.bottomAnchor, constant: 12).isActive = true
        loginRegisterButton.widthAnchor.constraint(equalTo: containerView.widthAnchor).isActive = true
        loginRegisterButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
   
    
    
    
    
    
}
