//
//  MuseumVC.swift
//  MYouSeeEm
//
//  Created by Angel Onuoha on 3/5/20.
//  Copyright © 2020 MYouSeeEm. All rights reserved.
//

import Foundation
import UIKit

class MuseumVC: UIViewController {
    
    var museumData: MuseumModel?
    var titlesForSection: Array<String>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepare()
    }
    
    func prepare() {
        if let museumData = museumData {
            self.title = "\(museumData.geography)"
            titlesForSection = (Array<String>(museumData.museums.keys)).sorted()
        }
    }
    
}
extension MuseumVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return museumData?.museums.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return titlesForSection[section]
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let museumData = museumData {
            let index = museumData.museums.index(forKey: titlesForSection[section])
            return museumData.museums[index!].value.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MuseumTableViewCell", for: indexPath) as! MuseumTableViewCell
        if let museumData = museumData {
            let index = museumData.museums.index(forKey: titlesForSection[indexPath.section])
            let museum = museumData.museums[index!].value
            let museumKeys = (Array<String>(museum.keys)).sorted()
            let keyIndex = museum.index(forKey: museumKeys[indexPath.row])
            cell.museumName.text = museumKeys[indexPath.row]
            cell.museumURL = museum[keyIndex!].value
        }
        return cell
    }
   
}
