//
//  SignInViewController.swift
//  MYouSeeEm
//
//  Created by Angel Onuoha on 3/2/20.
//  Copyright © 2020 MYouSeeEm. All rights reserved.
//

import Foundation
import UIKit
import FirebaseUI
import FirebaseDatabase

var ref: DatabaseReference!
var displayName = "Anonymous"
var messages = [DataSnapshot]()

class SignInViewController: UIViewController, FUIAuthDelegate {
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var stackView: UIStackView!
    
    fileprivate var _authHandle: AuthStateDidChangeListenerHandle!
    var user: User?
    var onboardingPictures: [String] = ["first", "second", "third", "fourth"]
    
    fileprivate func setupSignInButton() {
        signInButton.layer.cornerRadius = 2.0
        signInButton.layer.shadowColor = UIColor.black.cgColor
        signInButton.layer.shadowOffset = CGSize(width: 0.25, height: 0.8)
        signInButton.layer.shadowRadius = 0.6
        signInButton.layer.shadowOpacity = 0.7
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        activityIndicator.startAnimating()
        configureAuth()
        setupSignInButton()
        setNavLogo()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        signInButton.isHidden = true
    }
    
    deinit {
        Auth.auth().removeStateDidChangeListener(_authHandle)
    }
    
    func setNavLogo() {
        let logo = UIImage(named: "MYouSeeEmLogo")
        let imageView = UIImageView(image:logo)
        imageView.contentMode = .scaleAspectFit
        self.navigationItem.titleView = imageView
    }
    
    func configureAuth() {
        let authUI = FUIAuth.defaultAuthUI()
        authUI?.delegate = self
        let providers: [FUIAuthProvider] = [FUIEmailAuth(), FUIGoogleAuth(), FUIFacebookAuth()]
        authUI?.providers = providers
        _authHandle = Auth.auth().addStateDidChangeListener({ (auth: Auth, user: User?) in
            print("1")
            if let activeUser = user {
                 print("2")
                if self.user != activeUser {
                     print("3")
                    self.user = activeUser
                    if let name = user!.email?.components(separatedBy: "@")[0] {
                        displayName = name
                    }
                    self.signedInStatus(isSignedIn: true)
                }
            } else {
                 print("4")
                self.activityIndicator.stopAnimating()
                self.signInButton.isHidden = false
                self.signedInStatus(isSignedIn: false)
            }
        })
    }
    
    func signedInStatus(isSignedIn: Bool) {
        if isSignedIn {
            if self.signInButton.isHidden {
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

extension FUIAuthBaseViewController{
    func setFirebaseNavLogo() {
        let logo = UIImage(named: "MYouSeeEmLogo")
        let imageView = UIImageView(image:logo)
        imageView.contentMode = .scaleAspectFit
        self.navigationItem.titleView = imageView
    }
  open override func viewWillAppear(_ animated: Bool) {
    self.navigationItem.leftBarButtonItem = nil
    setFirebaseNavLogo()
  }
}

