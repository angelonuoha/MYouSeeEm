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
    @IBOutlet weak var stackView: UIStackView!
    
    fileprivate var _authHandle: AuthStateDidChangeListenerHandle!
    var user: User?
    var onboardingPictures: [String] = ["first", "second", "third", "fourth"]
    var isMFAEnabled = false
    
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
        setupGoogleLogin()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        signInButton.isHidden = true
        googleSignIn.isHidden = true
        setupFacebookLogin()
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
        loginButton.layer.cornerRadius = 2.0
        loginButton.layer.shadowColor = UIColor.black.cgColor
        loginButton.layer.shadowOffset = CGSize(width: 0.25, height: 0.8)
        loginButton.layer.shadowRadius = 0.6
        loginButton.layer.shadowOpacity = 0.7
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        let widthContraints =  NSLayoutConstraint(item: loginButton, attribute: NSLayoutConstraint.Attribute.width, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: 268)
        let heightContraints = NSLayoutConstraint(item: loginButton, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1.2, constant: 200)
        NSLayoutConstraint.activate([heightContraints,widthContraints])
        loginButton.delegate = self
        stackView.addArrangedSubview(loginButton)
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
        let providers: [FUIAuthProvider] = [FUIEmailAuth()/*, FUIGoogleAuth(), FUIFacebookAuth()*/]
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
    
}

extension SignInViewController: GIDSignInDelegate {
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error?) {
        guard error != nil else { return }
        if user == nil { return }
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

extension SignInViewController: LoginButtonDelegate {
    func loginButtonDidLogOut(_ loginButton: FBLoginButton) {
        do {
            try Auth.auth().signOut()
            navigationController?.popToRootViewController(animated: true)
        } catch {
            fatalError()
        }
    }
    
    func loginButton(_ loginButton: FBLoginButton, didCompleteWith result: LoginManagerLoginResult?, error: Error?) {
        guard let accessToken = AccessToken.current else {
            print("Failed to get access token")
            return
        }
        let credential = FacebookAuthProvider.credential(withAccessToken: accessToken.tokenString)
        Auth.auth().signIn(with: credential) { (authResult, error) in
            if let error = error {
                let authError = error as NSError
                if (self.isMFAEnabled && authError.code == AuthErrorCode.secondFactorRequired.rawValue) {
                    // The user is a multi-factor user. Second factor challenge is required.
                    let resolver = authError.userInfo[AuthErrorUserInfoMultiFactorResolverKey] as! MultiFactorResolver
                    var displayNameString = ""
                    for tmpFactorInfo in (resolver.hints) {
                        displayNameString += tmpFactorInfo.displayName ?? ""
                        displayNameString += " "
                    }
                    self.showTextInputPrompt(withMessage: "Select factor to sign in\n\(displayNameString)", completionBlock: { userPressedOK, displayName in
                        var selectedHint: PhoneMultiFactorInfo?
                        for tmpFactorInfo in resolver.hints {
                            if (displayName == tmpFactorInfo.displayName) {
                                selectedHint = tmpFactorInfo as? PhoneMultiFactorInfo
                            }
                        }
                        PhoneAuthProvider.provider().verifyPhoneNumber(with: selectedHint!, uiDelegate: nil, multiFactorSession: resolver.session) { verificationID, error in
                            if error != nil {
                                print("Multi factor start sign in failed. Error: \(error.debugDescription)")
                            } else {
                                self.showTextInputPrompt(withMessage: "Verification code for \(selectedHint?.displayName ?? "")", completionBlock: { userPressedOK, verificationCode in
                                    let credential: PhoneAuthCredential? = PhoneAuthProvider.provider().credential(withVerificationID: verificationID!, verificationCode: verificationCode!)
                                    let assertion: MultiFactorAssertion? = PhoneMultiFactorGenerator.assertion(with: credential!)
                                    resolver.resolveSignIn(with: assertion!) { authResult, error in
                                        if error != nil {
                                            print("Multi factor finalize sign in failed. Error: \(error.debugDescription)")
                                        } else {
                                            self.navigationController?.popViewController(animated: true)
                                        }
                                    }
                                })
                            }
                        }
                    })
                } else {
                    self.showMessagePrompt(error.localizedDescription)
                    return
                }
                // ...
                return
            }
            
            self.performSegue(withIdentifier: "LoggedIn", sender: self.user)
        }
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

