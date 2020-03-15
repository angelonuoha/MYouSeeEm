//
//  HomeResultsVC.swift
//  MYouSeeEm
//
//  Created by Angel Onuoha on 3/5/20.
//  Copyright © 2020 MYouSeeEm. All rights reserved.
//

import Foundation
import UIKit
import FirebaseDatabase
import GoneVisible

class HomeResultsVC: UIViewController {
    @IBOutlet weak var resultImageView: UIImageView!
    @IBOutlet weak var resultDescription: UITextView!
    @IBOutlet weak var instagramHandle: UILabel!
    @IBOutlet weak var instagramLabel: UILabel!
    @IBOutlet weak var instagramHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var instagramView: UIView!
    @IBOutlet weak var author: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var authorView: UIView!
    @IBOutlet weak var authorHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var dateHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var additionalInfo: UILabel!
    @IBOutlet weak var commentsTableView: UITableView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var commentsCount: UILabel!
    @IBOutlet weak var songLabel: UILabel!
    @IBOutlet weak var appleMusic: UIButton!
    @IBOutlet weak var spotify: UIButton!
    @IBOutlet weak var commentTextField: UITextField!
    @IBOutlet weak var artistDescription: UITextView!
    @IBOutlet weak var artistProfileImage: UIImageView!
    @IBOutlet weak var descriptionHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var shadowView: UIView!
    @IBOutlet weak var commentsView: UIView!
    
    var subcategoryDetail: SubcategoryModel?
    var artist: ArtistModel?
    var isArtist: Bool {
        return artist != nil
    }
    var keyboardOnScreen = false
    fileprivate var _refHandle: DatabaseHandle!
    var comments: [DataSnapshot]! = []
    var msglength: NSNumber = 1000
    var commentsExists: Bool {
        return comments!.count > 0
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepare()
        scrollView.scrollToTop(animated: true)
        suscribeToKeyboardNotifications()
        shadowView.clipsToBounds = false
        commentsView.layer.cornerRadius = 10
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        unsuscribeToKeyboardNotifications()
    }
    
    
    func prepare() {
        if isArtist {
            if let artist = artist {
                self.title = "\(artist.name)"
                artistProfileImage?.image = returnArtistImage(artist: artist.name)
                artistDescription?.attributedText = addDescription(description: artist.description)
                additionalInfo?.text = artist.additionalInfo
                songLabel?.text = "Checkout their song in the MYouSeeEm Playlist: \(artist.song)"
                artistDescription.isScrollEnabled = true
                artistDescription.isEditable = false
            }
            hideLabels(author: author, authorLabel: authorLabel, instagramHandle: instagramHandle, instagramLabel: instagramLabel, date: date)
        } else {
            if let subcategoryDetail = subcategoryDetail {
                resultImageView.image = returnImage(category: subcategoryDetail.category, subcategory: subcategoryDetail.subcategory, photoId: subcategoryDetail.photoId)
                self.title = subcategoryDetail.photoId
                resultDescription.attributedText = addDescription(description: subcategoryDetail.description)
                resultDescription.isScrollEnabled = true
                resultDescription.isEditable = false
                instagramHandle.text = subcategoryDetail.instagram
                author.text = subcategoryDetail.author
                date.text = subcategoryDetail.date
                additionalInfo.text = "Additional Info: \(subcategoryDetail.additionalInfo)"
            }
            hideArtistLabels(songLabel: songLabel, appleMusic: appleMusic, spotify: spotify)
        }
        downloadComments()
    }
    
    func downloadComments() {
        if isArtist {
            if let artist = artist {
                ref.child("Comments/Artist Spotlight/\(artist.name)/comments").observeSingleEvent(of: .value, with: { (snapshot) in
                    let enumerator = snapshot.children
                    while let rest = enumerator.nextObject() as? DataSnapshot {
                        self.comments.append(rest)
                    }
                    self.commentsCount.text = String(self.comments.count)
                }){ (error) in
                    print(error.localizedDescription)
                }
            }
        } else if let subcategoryDetail = subcategoryDetail {
            ref.child("Comments/\(subcategoryDetail.category)/\(subcategoryDetail.subcategory)/comments").observeSingleEvent(of: .value, with: { (snapshot) in
                let enumerator = snapshot.children
                while let rest = enumerator.nextObject() as? DataSnapshot {
                    self.comments.append(rest)
                }
                self.commentsCount.text = String(self.comments.count)
            }){ (error) in
                print(error.localizedDescription)
            }
        }
    }
    /*
    func handleComments() {
        if !commentsExists { tableHeightConstraint.constant = 0 }
        noCommentsLabel.isHidden = commentsExists
        commentsTableView.isHidden = !commentsExists
        self.commentsTableView.reloadData()
    }
    
    func listenForComments() {
        if isArtist {
            if let artist = artist {
                _refHandle = ref.child("Comments/Artist Spotlight/\(artist.name)/comments").observe(.childAdded) { (snapshot: DataSnapshot) in
                    self.comments.append(snapshot)
                    self.commentsTableView.insertRows(at: [IndexPath(row: self.comments.count-1, section: 0)], with: .automatic)
                    self.scrollToBottomMessage()
                }
            }
        } else {
            if let subcategoryDetail = subcategoryDetail {
                _refHandle = ref.child("Comments/\(subcategoryDetail.category)/\(subcategoryDetail.subcategory)/comments").observe(.childAdded) { (snapshot: DataSnapshot) in
                    self.comments.append(snapshot)
                    self.commentsTableView.insertRows(at: [IndexPath(row: self.comments.count-1, section: 0)], with: .automatic)
                    self.scrollToBottomMessage()
                }
            }
        }
        
    }
 */
    
    func hideLabels(author: UILabel, authorLabel: UILabel, instagramHandle: UILabel, instagramLabel: UILabel, date: UILabel) {
        authorView.gone()
        authorHeightConstraint.constant = 0
        instagramView.gone()
        instagramHeightConstraint.constant = 0
        dateHeightConstraint.constant = 0
        stackView.spacing = 0
    }
    
    func hideArtistLabels(songLabel: UILabel, appleMusic: UIButton, spotify: UIButton) {
        songLabel.isHidden = !isArtist
        appleMusic.isHidden = !isArtist
        spotify.isHidden = !isArtist
    }
    
    func addDescription(description: String) -> NSAttributedString {
        let attributedString = NSMutableAttributedString()
            .bold("Description: ")
            .normal(description)
        return attributedString
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
    
    func returnImage(category: String, subcategory: String, photoId: String) -> UIImage? {
        let categoryName = category.lowercased().replacingOccurrences(of: " ", with: "").replacingOccurrences(of: "-", with: "")
        let subcategoryName = subcategory.lowercased().replacingOccurrences(of: " ", with: "").replacingOccurrences(of: "-", with: "")
        let photoIdentifier = photoId.lowercased().replacingOccurrences(of: " ", with: "").replacingOccurrences(of: "-", with: "")
        return UIImage(named: "\(categoryName).\(subcategoryName).\(photoIdentifier)")
    }
    
    func returnArtistImage(artist: String) -> UIImage? {
        let artistName = artist.lowercased().replacingOccurrences(of: " ", with: "").replacingOccurrences(of: "-", with: "")
        return UIImage(named: "artistspotlight.\(artistName)")
    }
    
    // MARK: Comments
    
    func sendMessage(data: [String: Any]) {
        if isArtist {
            if let artist = artist {
                ref.child("Comments/Artist Spotlight/\(artist.name)/comments").childByAutoId().setValue(data)
            }
        } else {
            if let subcategoryDetail = subcategoryDetail {
                ref.child("Comments/\(subcategoryDetail.category)/\(subcategoryDetail.subcategory)/\(subcategoryDetail.photoId)/comments").childByAutoId().setValue(data)
            }
        }
    }
    
    func convertDateToString(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let myString = formatter.string(from: date)
        let date = formatter.date(from: myString)
        formatter.dateFormat = "dd-MMM-yyyy"
        let dateAsString = formatter.string(from: date!)
        return dateAsString
    }
    
    @IBAction func didSendMessage(_ sender: Any) {
        let _ = textFieldShouldReturn(commentTextField)
        commentTextField.text = ""
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? HomeCommentsVC {
            vc.artist = artist
            vc.subcategoryDetail = subcategoryDetail
            vc.comments = comments
        }
    }
    
    @IBAction func seeAllComments(_ sender: Any) {
        performSegue(withIdentifier: "SeeAllComments", sender: nil)
    }
    
}

extension HomeResultsVC: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // set the maximum length of the message
        guard let text = textField.text else { return true }
        let newLength = text.utf16.count + string.utf16.count - range.length
        return newLength <= msglength.intValue
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if !textField.text!.isEmpty {
            let date = Date()
            let dateString = convertDateToString(date: date)
            if let currentUser = currentUser {
                let data = [Constants.MessageFields.comment: textField.text! as String,
                            Constants.MessageFields.name: currentUser.displayName!,
                            Constants.MessageFields.date: dateString]
                sendMessage(data: data)
            } else {
                print("error")
            }
            textField.resignFirstResponder()
        }
        return true
    }
    
    // MARK: Show/Hide Keyboard
    
    // Keyboard Shift Functions
    func getKeyboardHeight(_ notification: Notification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.cgRectValue.height
    }
    
    func suscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func unsuscribeToKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        if commentTextField.isEditing {
            view.frame.origin.y = -getKeyboardHeight(notification)
        }
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        view.frame.origin.y = 0
    }
}

extension NSMutableAttributedString {
    var fontSize:CGFloat { return 17 }
    var boldFont:UIFont { return UIFont(name: "Helvetica Neue Bold", size: fontSize) ?? UIFont.boldSystemFont(ofSize: fontSize) }
    var normalFont:UIFont { return UIFont(name: "Helvetica Neue", size: fontSize) ?? UIFont.systemFont(ofSize: fontSize)}

    func bold(_ value:String) -> NSMutableAttributedString {

        let attributes:[NSAttributedString.Key : Any] = [
            .font : boldFont
        ]

        self.append(NSAttributedString(string: value, attributes:attributes))
        return self
    }

    func normal(_ value:String) -> NSMutableAttributedString {

        let attributes:[NSAttributedString.Key : Any] = [
            .font : normalFont,
        ]

        self.append(NSAttributedString(string: value, attributes:attributes))
        return self
    }
    /* Other styling methods */
    func orangeHighlight(_ value:String) -> NSMutableAttributedString {

        let attributes:[NSAttributedString.Key : Any] = [
            .font :  normalFont,
            .foregroundColor : UIColor.white,
            .backgroundColor : UIColor.orange
        ]

        self.append(NSAttributedString(string: value, attributes:attributes))
        return self
    }

    func blackHighlight(_ value:String) -> NSMutableAttributedString {

        let attributes:[NSAttributedString.Key : Any] = [
            .font :  normalFont,
            .foregroundColor : UIColor.white,
            .backgroundColor : UIColor.black

        ]

        self.append(NSAttributedString(string: value, attributes:attributes))
        return self
    }

    func underlined(_ value:String) -> NSMutableAttributedString {

        let attributes:[NSAttributedString.Key : Any] = [
            .font :  normalFont,
            .underlineStyle : NSUnderlineStyle.single.rawValue

        ]

        self.append(NSAttributedString(string: value, attributes:attributes))
        return self
    }
}
