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
import FacebookCore
import FacebookLogin

var ref: DatabaseReference!
var displayName = "Anonymous"
var messages = [DataSnapshot]()

class SignInViewController: UIViewController, FUIAuthDelegate {
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet var googleSignIn: GIDSignInButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    fileprivate var _authHandle: AuthStateDidChangeListenerHandle!
    var user: User?
    var onboardingPictures: [String] = ["first", "second", "third", "fourth"]
    var isMFAEnabled = false
    
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
        setNavLogo()
        setupGoogleLogin()
        setupFacebookLogin()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        signInButton.isHidden = true
        googleSignIn.isHidden = true
    }
    
    deinit {
        Auth.auth().removeStateDidChangeListener(_authHandle)
    }
    
    func setupGoogleLogin() {
        GIDSignIn.sharedInstance()?.presentingViewController = self
        GIDSignIn.sharedInstance().delegate = self
    }
    
    func setupFacebookLogin() {
        let loginButton = FBLoginButton()
        //loginButton.delegate = self
    }
    func setNavLogo() {
        let logo = UIImage(named: "MYouSeeEmFullLogo")
        let imageView = UIImageView(image:logo)
        imageView.contentMode = .scaleAspectFit
        self.navigationItem.titleView = imageView
    }
    
    func configureAuth() {
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
                performSegue(withIdentifier: "LoggedIn", sender: user)
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
        performSegue(withIdentifier: "LoggedIn", sender: user)
    }
    
    
    @IBAction func signIn(_ sender: Any) {
        // Firebase
        self.signedInStatus(isSignedIn: false)
        self.loginSession()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? HomeVC {
            vc.profile = sender as? User
        }
    }
    
    func showMessagePrompt(_ message: String, title: String? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    func showTextInputPrompt(withMessage: String, completionBlock: @escaping (Bool, String?) -> Void) {
        let alert = UIAlertController(title: "Add New Name", message: withMessage, preferredStyle: .alert)
        alert.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "Enter"
        }
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func facebookLogin(sender: UIButton) {
        let fbLoginManager = LoginManager()
        fbLoginManager.logIn(permissions: ["public_profile", "email"], from: self) { (result, error) in
            if let error = error {
                print("Failed to login: \(error.localizedDescription)")
                return
            }
            
            guard let accessToken = AccessToken.current else {
                print("Failed to get access token")
                return
            }
     
            let credential = FacebookAuthProvider.credential(withAccessToken: accessToken.tokenString)
            
            // Perform login by calling Firebase APIs
            Auth.auth().signIn(with: credential, completion: { (user, error) in
                if let error = error {
                    print("Login error: \(error.localizedDescription)")
                    let alertController = UIAlertController(title: "Login Error", message: error.localizedDescription, preferredStyle: .alert)
                    let okayAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alertController.addAction(okayAction)
                    self.present(alertController, animated: true, completion: nil)
                    return
                }
                // Present the main view
                self.performSegue(withIdentifier: "LoggedIn", sender: nil)
            })
     
        }
    }
    
}

extension SignInViewController: GIDSignInDelegate {
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error?) {
        guard error != nil else { return }

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

extension SignInViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return onboardingPictures.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SignInViewCell", for: indexPath) as! SignInViewCell
        cell.onboardingPictures = onboardingPictures[indexPath.row]
        return cell
    }
}

extension SignInViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let w = collectionView.bounds.width
        let m = w - 1
        return .init(width: m, height: w)
    }
}

