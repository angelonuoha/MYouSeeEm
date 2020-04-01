//
//  MenuVC.swift
//  MYouSeeEm
//
//  Created by Angel Onuoha on 3/2/20.
//  Copyright © 2020 MYouSeeEm. All rights reserved.
//

import Foundation
import UIKit
import FirebaseUI
import FirebaseStorage

protocol ProfileMenuDelegate {
    func showAboutUs()
    func showEvents()
    func showMuseumsToVisit()
    func contactUs()
    func signOut()
    func loadProfile() -> User?
    func loadProfileImage(completion: @escaping (UIImage?) -> Void)
}

class MenuVC: UIViewController {
    
    @IBOutlet weak var profileImageView: RoundImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var aboutUs: UIButton!
    @IBOutlet weak var events: UIButton!
    @IBOutlet weak var signOut: UIButton!
    
    var delegate: ProfileMenuDelegate?
    var profile: User?
    
    static func instantiate() -> MenuVC {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: "MenuVC") as! MenuVC
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        prepare()
    }
    
    func prepare() {
        guard let profile = self.delegate?.loadProfile() else { return }
        usernameLabel.text = profile.displayName
        print("menuvc delegate")
        self.delegate?.loadProfileImage(completion: { (profileImg) in
            self.profileImageView.image = profileImg
            print(profileImg)
        })
    }
    
    func saveProfilePictureToStorage(image: UIImage) {
        let photoData = UIImage.jpegData(image)
        let imagePath = "profile_pictures/" + "\(Auth.auth().currentUser!.uid)" + ".jpg"
            let metadata = StorageMetadata()
            metadata.contentType = "image/jpeg"
            storageRef!.child(imagePath).putData(photoData(0.8)!, metadata: metadata, completion: { (metadata, error) in
                if let error = error {
                    print("error uploading: \(error)")
                    return
                }
                let data = storageRef!.child((metadata?.path)!).description
                ref.child("Users").child(Auth.auth().currentUser!.uid).setValue(data)
            })
    }
    
    @IBAction func showAboutUs(_ sender: Any) {
        delegate?.showAboutUs()
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func showEvents(_ sender: Any) {
        delegate?.showEvents()
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func showMuseums(_ sender: Any) {
        delegate?.showMuseumsToVisit()
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func changeProfilePicture(_ sender: Any) {
        let controller = UIImagePickerController()
        controller.delegate = self
        present(controller, animated: true, completion: nil)
    }
    
    @IBAction func appleMusic(_ sender: Any) {
        if let url = URL(string: "https://music.apple.com/us/playlist/myouseeem-playlist/pl.u-e98lGdKI19okXp") {
            UIApplication.shared.open(url)
        }
    }
    @IBAction func spotify(_ sender: Any) {
        if let url = URL(string: "https://open.spotify.com/playlist/04Rumhya7JTH1DqRxX856D") {
            UIApplication.shared.open(url)
        }
    }

    
    @IBAction func contactUs(_ sender: Any) {
        delegate?.contactUs()
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func signOut(_ sender: Any) {
        delegate?.signOut()
        dismiss(animated: true, completion: nil)
    }
 
}

extension MenuVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        profileImageView.image = image
        saveProfilePictureToStorage(image: image)
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}
