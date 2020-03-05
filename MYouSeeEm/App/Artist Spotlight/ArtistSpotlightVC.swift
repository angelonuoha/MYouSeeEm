//
//  ArtistSpotlightVC.swift
//  MYouSeeEm
//
//  Created by Angel Onuoha on 3/4/20.
//  Copyright © 2020 MYouSeeEm. All rights reserved.
//

import UIKit

class ArtistSpotlightVC: UIViewController {
    @IBOutlet weak var artistProfileImage: UIImageView!
    @IBOutlet weak var artistDescription: UITextView!
    @IBOutlet weak var songLabel: UILabel!
    
    var artist: ArtistModel?
    
    func prepare() {
        if let artist = artist {
            self.title = "\(artist.name)"
            artistProfileImage?.image = returnImage(artist: artist.name)
            artistDescription?.text = artist.description
            songLabel?.text = "Checkout their song in the MYouSeeEm Playlist: \(artist.song)"
            artistDescription.isScrollEnabled = false
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        prepare()
    }
    
    func returnImage(artist: String) -> UIImage? {
        let artistName = artist.lowercased().replacingOccurrences(of: " ", with: "").replacingOccurrences(of: "-", with: "")
        return UIImage(named: "artistspotlight.\(artistName)")
    }
    
    
    @IBAction func linkToApplePlaylist(_ sender: Any) {
        if let url = URL(string: "https://music.apple.com/us/playlist/myouseeem-playlist/pl.u-e98lGdKI19okXp") {
            UIApplication.shared.open(url)
        }
    }
    
    @IBAction func linkToSpotifyPlaylist(_ sender: Any) {
        if let url = URL(string: "https://open.spotify.com/playlist/04Rumhya7JTH1DqRxX856D") {
            UIApplication.shared.open(url)
        }
    }
    
    
}
