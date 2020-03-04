//
//  SignInViewController.swift
//  MYouSeeEm
//
//  Created by Angel Onuoha on 3/2/20.
//  Copyright © 2020 MYouSeeEm. All rights reserved.
//

import Foundation
import UIKit
import GoogleSignIn
import FirebaseUI
import FirebaseDatabase

var ref: DatabaseReference!
var displayName = "Anonymous"
var messages = [DataSnapshot]()

class SignInViewController: UIViewController, FUIAuthDelegate {
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet var googleSignIn: GIDSignInButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    fileprivate var _authHandle: AuthStateDidChangeListenerHandle!
    var user: User?
    
    
    
    fileprivate func setupSignInButton() {
        signInButton.layer.cornerRadius = 3.0
        signInButton.layer.shadowColor = UIColor.black.cgColor
        signInButton.layer.shadowOffset = CGSize(width: 0.25, height: 0.8)
        signInButton.layer.shadowRadius = 0.8
        signInButton.layer.shadowOpacity = 0.7
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        activityIndicator.startAnimating()
        configureAuth()
        setupSignInButton()
        
        //Google
        GIDSignIn.sharedInstance()?.presentingViewController = self
        GIDSignIn.sharedInstance().delegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        signInButton.isHidden = true
        googleSignIn.isHidden = true
    }
    
    deinit {
        Auth.auth().removeStateDidChangeListener(_authHandle)
    }
    
    func configureAuth() {
        print("configuring auth")
        let authUI = FUIAuth.defaultAuthUI()
        authUI?.delegate = self
        let providers: [FUIAuthProvider] = [FUIEmailAuth()]
        authUI?.providers = providers
        _authHandle = Auth.auth().addStateDidChangeListener({ (auth: Auth, user: User?) in
            if let activeUser = user {
                if self.user != activeUser {
                    self.user = activeUser
                    let name = user!.email!.components(separatedBy: "@")[0]
                    displayName = name
                    self.signedInStatus(isSignedIn: true)
                }
            } else {
                self.activityIndicator.stopAnimating()
                self.signInButton.isHidden = false
                self.googleSignIn.isHidden = false
                self.signedInStatus(isSignedIn: false)
            }
        })
    }
    
    func signedInStatus(isSignedIn: Bool) {
        if isSignedIn {
            if self.signInButton.isHidden && self.googleSignIn.isHidden {
                performSegue(withIdentifier: "LoggedIn", sender: nil)
            }
            activityIndicator.stopAnimating()
            configureDatabase()
        }
    }
    
    func configureDatabase() {
        ref = Database.database().reference()
    }
    
    func loginSession() {
        activityIndicator.stopAnimating()
        let authViewController = FUIAuth.defaultAuthUI()!.authViewController()
        present(authViewController, animated: true, completion: nil)
    }
    
    func authUI(_ authUI: FUIAuth, didSignInWith authDataResult: AuthDataResult?, error: Error?) {
        print("signed in")
        performSegue(withIdentifier: "LoggedIn", sender: nil)
    }
    
    
    @IBAction func signIn(_ sender: Any) {
        // Firebase
        self.signedInStatus(isSignedIn: false)
        self.loginSession()
    }
    
}

extension SignInViewController: GIDSignInDelegate {
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error?) {
      if let error = error {
        print(error)
        return
      }

      guard let authentication = user.authentication else { return }
      let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken,
                                                        accessToken: authentication.accessToken)
      Auth.auth().signIn(with: credential) { (authResult, error) in
        if let error = error {
          print(error)
          return
        }
        self.performSegue(withIdentifier: "LoggedIn", sender: nil)
      }
    }

    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        // Perform any operations when the user disconnects from app here.
    }
}

