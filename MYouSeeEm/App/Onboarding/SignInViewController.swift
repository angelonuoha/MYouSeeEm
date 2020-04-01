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
import FirebaseStorage

var ref: DatabaseReference!
var storageRef: StorageReference!
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
    var profileImageURL: String?
    
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
            if let activeUser = user {
                if self.user != activeUser {
                    self.user = activeUser
                    self.signedInStatus(isSignedIn: true)
                    if let name = user!.email?.components(separatedBy: "@")[0] {
                        displayName = name
                    }
                    self.addProfilePicToDatabase(user: activeUser)
                }
            } else {
                self.activityIndicator.stopAnimating()
                self.signInButton.isHidden = false
                self.signedInStatus(isSignedIn: false)
            }
        })
    }
    
    func saveProfilePicture(image: UIImage, completion: @escaping () -> Void) {
        let photoData = UIImage.jpegData(image)
            let imagePath = "profile_pictures/" + "\(Auth.auth().currentUser!.uid)" + ".jpg"
            let metadata = StorageMetadata()
            metadata.contentType = "image/jpeg"
            storageRef!.child(imagePath).putData(photoData(0.8)!, metadata: metadata, completion: { (metadata, error) in
                if let error = error {
                    print("error uploading: \(error)")
                    return
                }
                print("wrote to storage")
                let data = storageRef!.child((metadata?.path)!).description
                ref.child("Users").child(Auth.auth().currentUser!.uid).setValue(data)
                print("wrote to database")
                completion()
            })
    }
    
    func addProfilePicToDatabase(user: User) {
        ref.child("Users/\(user.uid)").observeSingleEvent(of: .value, with: { (snapshot) in
            if snapshot.exists() {
                self.performSegue(withIdentifier: "LoggedIn", sender: self.user)
                return
            } else {
                if let photoURL = user.photoURL {
                    let urlRequest = URLRequest(url: photoURL)
                    let task = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
                        guard let data = data else { return }
                        self.saveProfilePicture(image: UIImage(data: data)!, completion: {
                            self.configureProfilePicture { (imgURL) in
                                self.profileImageURL = imgURL
                                self.activityIndicator.stopAnimating()
                                self.signInButton.isHidden = false
                                self.performSegue(withIdentifier: "LoggedIn", sender: self.user)
                            }
                        })
                    }
                    task.resume()
                } else {
                    self.saveProfilePicture(image: UIImage(named: "profile-default")!, completion: {
                        self.configureProfilePicture { (imgURL) in
                            self.profileImageURL = imgURL
                            self.activityIndicator.stopAnimating()
                            self.signInButton.isHidden = false
                            self.performSegue(withIdentifier: "LoggedIn", sender: self.user)
                        }
                    })
                }
            }
        })
    }
    
    func configureProfilePicture(completion: @escaping (String?) -> Void) {
        ref.child("Users/\(Auth.auth().currentUser!.uid)").observeSingleEvent(of: .value) { (snapshot) in
            let imgURL = snapshot.value as? String
            self.profileImageURL = imgURL
            completion(imgURL)
        }
    }
    
    func signedInStatus(isSignedIn: Bool) {
        if isSignedIn {
            configureDatabase()
            configureStorage()
        }
    }
    
    func configureDatabase() {
        ref = Database.database().reference()
    }
    
    func configureStorage() {
        storageRef = Storage.storage().reference()
    }
    
    func loginSession() {
        activityIndicator.stopAnimating()
        let authUI = FUIAuth.defaultAuthUI()!
        let authViewController = MYouSeeEmAuthViewController(authUI: authUI)
        let navc = UINavigationController(rootViewController: authViewController)
        present(navc, animated: true, completion: nil)
    }
    
    func authUI(_ authUI: FUIAuth, didSignInWith authDataResult: AuthDataResult?, error: Error?) {

    }
    
    
    @IBAction func signIn(_ sender: Any) {
        // Firebase
        self.signedInStatus(isSignedIn: false)
        self.loginSession()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? HomeVC {
            vc.profile = sender as? User
            vc.profileImageURL = profileImageURL
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

