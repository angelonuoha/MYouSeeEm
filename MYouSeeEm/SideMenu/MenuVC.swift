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

protocol ProfileMenuDelegate {
    func showAboutUs()
    func showEvents()
    func showMuseumsToVisit()
    func contactUs()
    func signOut()
    func loadProfile() -> User?
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
        /*
        APISharedService.shared.userSession.currentProfile.bind { [weak self] userModel in
            self?.profile = userModel
        }
        .disposed(by: disposeBag)
 */
    }
    
    func prepare() {
        guard let profile = self.delegate?.loadProfile() else { return }
        print(profile)
        usernameLabel.text = profile.displayName
        //profileImageView.loadProfileImage(userId: profile.id)
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
    
    @IBAction func contactUs(_ sender: Any) {
        delegate?.contactUs()
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func signOut(_ sender: Any) {
        delegate?.signOut()
        dismiss(animated: true, completion: nil)
    }
    
 
}
