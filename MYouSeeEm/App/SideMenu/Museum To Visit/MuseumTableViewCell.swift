//
//  MuseumTableViewCell.swift
//  MYouSeeEm
//
//  Created by Angel Onuoha on 3/5/20.
//  Copyright © 2020 MYouSeeEm. All rights reserved.
//

import Foundation
import UIKit

class MuseumTableViewCell: UITableViewCell {
    @IBOutlet weak var museumName: UILabel!
    
    var museumURL: String? {
        didSet {
            prepare()
        }
    }
    
    func prepare() {
        if let museumURL = museumURL {
            if let url = URL(string: museumURL) {
                UIApplication.shared.open(url)
            }
        }
    }
}
