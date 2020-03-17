//
//  HomeCommentsVC.swift
//  MYouSeeEm
//
//  Created by Angel Onuoha on 3/14/20.
//  Copyright © 2020 MYouSeeEm. All rights reserved.
//

import Foundation
import UIKit
import FirebaseDatabase

class HomeCommentsVC: UIViewController {
    @IBOutlet weak var commentsTextField: UITextField!
    @IBOutlet weak var commentsTableView: UITableView!
    
    var keyboardOnScreen = false
    var subcategoryDetail: SubcategoryModel?
    var artist: ArtistModel?
    var comments: [DataSnapshot]!
    var msglength: NSNumber = 1000
    var commentsExists: Bool {
        return comments!.count > 0
    }
    var isArtist: Bool {
        return artist != nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        suscribeToKeyboardNotifications()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        unsuscribeToKeyboardNotifications()
    }
    
    func downloadComments() {
        if isArtist {
            if let artist = artist {
                ref.child("Comments/Artist Spotlight/\(artist.name)/comments").observeSingleEvent(of: .value, with: { (snapshot) in
                    let enumerator = snapshot.children
                    while let rest = enumerator.nextObject() as? DataSnapshot {
                        self.comments.append(rest)
                    }
                    //self.handleComments()
                }){ (error) in
                    print(error.localizedDescription)
                }
            }
        } else if let subcategoryDetail = subcategoryDetail {
            ref.child("Comments/\(subcategoryDetail.category)/\(subcategoryDetail.subcategory)/\(subcategoryDetail.photoId)/comments").observeSingleEvent(of: .value, with: { (snapshot) in
                let enumerator = snapshot.children
                while let rest = enumerator.nextObject() as? DataSnapshot {
                    self.comments.append(rest)
                }
                //self.handleComments()
            }){ (error) in
                print(error.localizedDescription)
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
        let _ = textFieldShouldReturn(commentsTextField)
        commentsTextField.text = ""
    }
    
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
    
    func scrollToBottomMessage() {
        if comments.count == 0 { return }
        let bottomMessageIndex = IndexPath(row: commentsTableView.numberOfRows(inSection: 0) - 1, section: 0)
        commentsTableView.scrollToRow(at: bottomMessageIndex, at: .bottom, animated: true)
    }
}

extension HomeCommentsVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HomeCommentsViewCell", for: indexPath) as! HomeCommentsViewCell
        let commentsSnapshot = comments[indexPath.row]
        let comments = commentsSnapshot.value as! [String: String]
        let name = comments[Constants.MessageFields.name] ?? "[username]"
        let comment = comments[Constants.MessageFields.comment] ?? "[message]"
        let date = comments[Constants.MessageFields.date] ?? "[date]"
        cell.commentLabel.text = comment
        cell.dateLabel.text = date
        cell.userName.text = name
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 85
    }
    
}

extension HomeCommentsVC: UITextFieldDelegate {
    
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
        if commentsTextField.isEditing {
            view.frame.origin.y = -getKeyboardHeight(notification)
        }
        scrollToBottomMessage()
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        view.frame.origin.y = 0
    }
}
