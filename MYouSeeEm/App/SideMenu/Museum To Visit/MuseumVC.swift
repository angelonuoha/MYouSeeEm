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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepare()
    }
    
    func prepare() {
        if let museumData = museumData {
            self.title = "\(museumData.geography)"
        }
    }
    
}
extension MuseumVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return museumData?.museums.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if let museumData = museumData {
            let titlesForSection = Array<String>(museumData.museums.keys)
            return titlesForSection[section]
        }
        return ""
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let museumData = museumData {
            let rowsForSection = Array<[String: String]>(museumData.museums.values)
            return rowsForSection[section].count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MuseumTableViewCell", for: indexPath) as! MuseumTableViewCell
        if let museumData = museumData {
            let rowsForSection = Array<[String: String]>(museumData.museums.values)
            let museumValue = Array<String>(rowsForSection[indexPath.section].values)
            let museumKey = Array<String>(rowsForSection[indexPath.section].keys)
            print(rowsForSection)
            cell.museumName.text = museumKey[indexPath.row]
            cell.museumURL = museumValue[indexPath.row]
        }
        return cell
    }
   
}
