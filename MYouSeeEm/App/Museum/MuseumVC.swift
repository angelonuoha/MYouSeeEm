//
//  MuseumVC.swift
//  MYouSeeEm
//
//  Created by Angel Onuoha on 3/5/20.
//  Copyright © 2020 MYouSeeEm. All rights reserved.
//

import Foundation
import UIKit

class MuseumVC: UITableViewController {
    
    var museumData: MuseumModel?
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return museumData?.museums.count ?? 0
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MuseumTableViewCell", for: indexPath) as! MuseumTableViewCell
        if let museumData = museumData {
            cell.museumName.text = museumData.museums[indexPath.row]
        }
        return cell
    }
   
}
