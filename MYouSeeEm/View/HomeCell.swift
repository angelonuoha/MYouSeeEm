//
//  HomeCell.swift
//  MYouSeeEm
//
//  Created by Angel Onuoha on 3/1/20.
//  Copyright © 2020 MYouSeeEm. All rights reserved.
//

import Foundation
import UIKit
import FirebaseDatabase

protocol HomeCellDelegate {
    func makeLoadingView(visible: Bool)
    func showArtist(artist: ArtistModel)
    func showSubcategories(subcategory: CategoryModel)
}

class HomeCell: UITableViewCell {

    @IBOutlet weak var categoryTitleLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var delegate: HomeCellDelegate?
    
    override func awakeFromNib() {
        collectionView.dataSource = self
        collectionView.delegate = self
        
    }
    
    var isArtistSpotlight: Bool {
        return artists.count > 0
    }
    
    var data: [Any]!
    var categoryData: DataSnapshot!
    
    // Category and subcategories = for categories
    var category: String? {
        didSet {
            prepare()
        }
    }
    var subcategories: [String] = [] {
        didSet {
            collectionView.reloadData()
        }
    }
    
    var artists: [String] = [] {
        didSet {
            collectionView.reloadData()
        }
    }
    
    func prepare() {
        categoryTitleLabel.text = category
        self.downloadSubcategoriesFromFirebase(category: category)
    }
    func downloadSubcategoriesFromFirebase(category: String?) {
        
        if let category = category {
            ref.child("Category/\(category)/").observeSingleEvent(of: .value, with: { (snapshot) in
                self.data = snapshot.children.allObjects as! [AnyObject]
                self.categoryData = snapshot
                let enumerator = snapshot.children
                while let rest = enumerator.nextObject() as? DataSnapshot {
                    let keys = rest.key
                    if category == "Artist Spotlight" {
                        self.artists.append(keys)
                    } else {
                        self.subcategories.append(keys)
                    }
                }
                self.delegate?.makeLoadingView(visible: false)
            }) { (error) in
                print(error.localizedDescription)
            }
        }
        
    }
    
    
}
extension HomeCell: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if isArtistSpotlight {
            return artists.count
        } else {
            return subcategories.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if isArtistSpotlight {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeArtistCell", for: indexPath) as! HomeArtistCell
            cell.artist = artists[indexPath.row]
            cell.category = category
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeSubcategoryCell", for: indexPath) as! HomeSubcategoryCell
            cell.subcategory = subcategories[indexPath.row]
            cell.category = category
            return cell
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if isArtistSpotlight{
            let selectedArtist = artists[indexPath.row]
            let artistSnapshot = data[indexPath.row] as! DataSnapshot
            let artistData = artistSnapshot.value as! [String: String]
            if let song = artistData[Constants.artistSpotlight.song], let artistDescription = artistData[Constants.artistSpotlight.description], let additionalInfo = artistData[Constants.artistSpotlight.additionalInfo] {
                let artist = ArtistModel(name: selectedArtist, description: artistDescription, additionalInfo: additionalInfo, song: song)
                self.delegate?.showArtist(artist: artist)
            }
        } else {
            let superCategory = category!
            let selectedCategory = subcategories[indexPath.row]
            let categorySnapshot = categoryData.value as! [String: [String: [String: String]]]
            let index = categorySnapshot.index(forKey: selectedCategory)
            let categoryData = categorySnapshot[index!].value
            let categoryNames = Array(categoryData.keys)
            let categoryObject = CategoryModel(categoryData: categoryData, names: categoryNames, superCategory: superCategory, category: selectedCategory)
            self.delegate?.showSubcategories(subcategory: categoryObject)
        }
        
        
        
    }
    
    
}

extension HomeCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: 130, height: 130)
    }
}
