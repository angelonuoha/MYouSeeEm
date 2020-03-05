//
//  HomeArtistCell.swift
//  MYouSeeEm
//
//  Created by Angel Onuoha on 3/4/20.
//  Copyright © 2020 MYouSeeEm. All rights reserved.
//

import Foundation
import UIKit

class HomeArtistCell: UICollectionViewCell {
    @IBOutlet weak var subcategoryImageView: UIImageView!
    @IBOutlet weak var subcategoryTitleBackView: UIView!
    @IBOutlet weak var subcategoryTitleLabel: UILabel!
    @IBOutlet weak var shadowView: UIView!
    
    override func awakeFromNib() {
        shadowView.clipsToBounds = false
    }
    
    var artist: String? {
        didSet {
            prepare()
        }
    }
    
    var category: String? {
        didSet {
            prepare()
        }
    }
    
    func returnImage(category: String, artist: String) -> UIImage? {
        let categoryName = category.lowercased().replacingOccurrences(of: " ", with: "").replacingOccurrences(of: "-", with: "")
        let artistName = artist.lowercased().replacingOccurrences(of: " ", with: "").replacingOccurrences(of: "-", with: "")
        return UIImage(named: "\(categoryName).\(artistName)")
    }
    
    func prepare() {
        guard let artist = artist else { return }
        guard let category = category else { return }
        subcategoryTitleLabel.text = artist
        subcategoryImageView.image = returnImage(category: category, artist: artist)
        
        
    }
}
