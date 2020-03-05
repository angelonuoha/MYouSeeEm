//
//  HomeVC.swift
//  MYouSeeEm
//
//  Created by Angel Onuoha on 3/1/20.
//  Copyright © 2020 MYouSeeEm. All rights reserved.
//

import Foundation
import UIKit
import FirebaseDatabase
import FirebaseAuth



class HomeVC: UIViewController {
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var loadingView: UIView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var categoriesTableView: UITableView!
    @IBOutlet weak var tableView: UITableView!
    
    var dataSnapshot: [DataSnapshot]! = []
    
    var artistSpotlight: [String] = [] {
        didSet {
            categoriesTableView.reloadData()
        }
    }
    
    var artists: [String] = []
    
    var categories: [String] = [] {
        didSet {
            categoriesTableView.reloadData()
        }
    }
    
    var subcategories: [String] = [] {
        didSet {
            categoriesTableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
    
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    
    
    func downloadCategoriesFromFirebase() {
        ref.child("Category").observeSingleEvent(of: .value, with: { (snapshot) in
            let enumerator = snapshot.children
            while let rest = enumerator.nextObject() as? DataSnapshot {
                //print(rest)
                
                let keys = rest.key
                if keys == "Artist Spotlight" {
                    self.artistSpotlight.append(keys)
                } else {
                    self.categories.append(keys)
                }
            }
            self.tableView.reloadData()
        }) { (error) in
            print(error.localizedDescription)
            print("error reading categories")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? ArtistSpotlightVC {
            vc.artist = sender as? ArtistModel
        }
        
        if let vc = segue.destination as? HomeCategoryVC {
            vc.subcategory = sender as? CategoryModel
        }
    }
    
    
    
    func loadData() {
        self.makeLoadingView(visible: true)
        // Load categories - home VC appears first and binding will remove the loading view before all the categories are loaded
        downloadCategoriesFromFirebase()
    }
    
}


extension HomeVC: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return artistSpotlight.count
        } else {
            return categories.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HomeCell", for: indexPath) as! HomeCell
        if indexPath.section == 0 {
            cell.category = artistSpotlight[indexPath.row]
            cell.artists = artists
        } else {
            cell.category = categories[indexPath.row]
            cell.subcategories = subcategories
        }
        cell.delegate = self
        return cell
    }
    
}

extension HomeVC: HomeCellDelegate {
    func makeLoadingView(visible: Bool) {
        loadingView.isHidden = !visible
        categoriesTableView.isHidden = visible
        if visible {
            activityIndicator.startAnimating()
        } else {
            activityIndicator.stopAnimating()
        }
    }
    func showArtist(artist: ArtistModel) {
        performSegue(withIdentifier: "ShowArtist", sender: artist)
    }
    func showSubcategories(subcategory: CategoryModel) {
        performSegue(withIdentifier: "ShowSubcategories", sender: subcategory)
    }
}
