//
//  MenuVC.swift
//  MYouSeeEm
//
//  Created by Angel Onuoha on 3/2/20.
//  Copyright © 2020 MYouSeeEm. All rights reserved.
//

import Foundation
import UIKit

protocol ProfileMenuDelegate {
    func showSettings()
    func showPayment()
    func contactUs()
    func signOut()
}

class MenuVC: UIViewController {
    
    @IBOutlet weak var profileImageView: RoundImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var profileSettingsButton: UIButton!
    @IBOutlet weak var paymentSettingsButton: UIButton!
    @IBOutlet weak var contactButton: UIButton!
    /*
    var delegate: ProfileMenuDelegate?
    var profile: APIUserModel? {
        didSet {
            prepare()
        }
    }
    
    static func instantiate() -> MenuVC {
        let storyboard = UIStoryboard(name: "Profile", bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: "MenuVC") as! MenuVC
    }

    override func viewDidLoad() {
        APISharedService.shared.userSession.currentProfile.bind { [weak self] userModel in
            self?.profile = userModel
        }
        .disposed(by: disposeBag)
    }
    
    func prepare() {
        guard let profile = profile else { return }
        usernameLabel.text = profile.fullName
        profileImageView.loadProfileImage(userId: profile.id)
    }
    
    @IBAction func openProfileSettings(_ sender: Any) {
        delegate?.showSettings()
        dismiss(animated: true, completion: nil)

    }
    
    @IBAction func openPaymentSettings(_ sender: Any) {
        delegate?.showPayment()
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func openContactUs(_ sender: Any) {
        delegate?.contactUs()
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func signOut(_ sender: Any) {
        delegate?.signOut()
        dismiss(animated: true, completion: nil)
    }
 */
}
