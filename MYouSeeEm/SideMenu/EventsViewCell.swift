//
//  EventsViewCell.swift
//  MYouSeeEm
//
//  Created by Angel Onuoha on 3/6/20.
//  Copyright © 2020 MYouSeeEm. All rights reserved.
//

import UIKit

class EventsViewCell: UITableViewCell {
    @IBOutlet weak var eventImageView: UIView!
    @IBOutlet weak var eventDate: UILabel!
    @IBOutlet weak var eventName: UILabel!
    @IBOutlet weak var eventDescription: UILabel!
    @IBOutlet weak var eventPrice: UILabel!
    @IBOutlet weak var shadowCellView: ShadowCellView!
    
    override func awakeFromNib() {
        shadowCellView.clipsToBounds = false
    }
}
