//
//  HomeResultsVC.swift
//  MYouSeeEm
//
//  Created by Angel Onuoha on 3/5/20.
//  Copyright © 2020 MYouSeeEm. All rights reserved.
//

import Foundation
import UIKit

class HomeResultsVC: UIViewController {
    @IBOutlet weak var resultImageView: UIImageView!
    @IBOutlet weak var resultDescription: UITextView!
    @IBOutlet weak var instagramHandle: UILabel!
    @IBOutlet weak var author: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var additionalInfo: UILabel!
    @IBOutlet weak var commentsTableView: UITableView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var noCommentsLabel: UILabel!
    @IBOutlet weak var songLabel: UILabel!
    @IBOutlet weak var appleMusic: UIButton!
    @IBOutlet weak var spotify: UIButton!
    @IBOutlet weak var artistDescription: UITextView!
    @IBOutlet weak var artistProfileImage: UIImageView!
    
    var subcategoryDetail: SubcategoryModel?
    var artist: ArtistModel?
    var isArtist: Bool {
        return artist != nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepare()
        scrollView.scrollToTop(animated: true)
    }
    
    func prepare() {
        if isArtist {
            if let artist = artist {
                noCommentsLabel.isHidden = true
                self.title = "\(artist.name)"
                artistProfileImage?.image = returnArtistImage(artist: artist.name)
                artistDescription?.text = artist.description
                songLabel?.text = "Checkout their song in the MYouSeeEm Playlist: \(artist.song)"
                artistDescription.isScrollEnabled = false
                artistDescription.isEditable = false
            }
            hideLabels(author: author, instagramHandle: instagramHandle, date: date, additionalInfo: additionalInfo)
        } else {
            if let subcategoryDetail = subcategoryDetail {
                noCommentsLabel.isHidden = true
                resultImageView.image = returnImage(category: subcategoryDetail.category, subcategory: subcategoryDetail.subcategory, photoId: subcategoryDetail.photoId)
                self.title = subcategoryDetail.photoId
                resultDescription.text = subcategoryDetail.description
                resultDescription.isScrollEnabled = false
                resultDescription.isEditable = false
                instagramHandle.text = subcategoryDetail.instagram
                author.text = subcategoryDetail.author
                date.text = subcategoryDetail.date
                additionalInfo.text = subcategoryDetail.additionalInfo
            }
            hideArtistLabels(songLabel: songLabel, appleMusic: appleMusic, spotify: spotify)
        }
    }
    
    func hideLabels(author: UILabel, instagramHandle: UILabel, date: UILabel, additionalInfo: UILabel) {
        author.isHidden = isArtist
        instagramHandle.isHidden = isArtist
        date.isHidden = isArtist
        additionalInfo.isHidden = isArtist
    }
    
    func hideArtistLabels(songLabel: UILabel, appleMusic: UIButton, spotify: UIButton) {
        songLabel.isHidden = !isArtist
        appleMusic.isHidden = !isArtist
        spotify.isHidden = !isArtist
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
}

extension HomeResultsVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HomeCommentsViewCell", for: indexPath) as! HomeCommentsViewCell
        cell.commentLabel.text = "Comment"
        cell.dateLabel.text = "Yesterday"
        cell.userName.text = "Angel Onuoha"
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 85
    }
    
    
}
