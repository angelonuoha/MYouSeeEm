//
//  EventsVC.swift
//  MYouSeeEm
//
//  Created by Angel Onuoha on 3/5/20.
//  Copyright © 2020 MYouSeeEm. All rights reserved.
//

import Foundation
import UIKit
import FirebaseDatabase

class EventsVC: UIViewController {
    @IBOutlet weak var eventsTableView: UITableView!
    @IBOutlet weak var loadingView: UIView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var events: [DataSnapshot]! = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        makeLoadingView(visible: true)
        loadEvents()
    }

    func makeLoadingView(visible: Bool) {
        loadingView.isHidden = !visible
        eventsTableView.isHidden = visible
        if visible {
            activityIndicator.startAnimating()
        } else {
            activityIndicator.stopAnimating()
        }
    }
    
    func loadEvents() {
        ref.child("Events").observeSingleEvent(of: .value, with: { (snapshot) in
            let enumerator = snapshot.children
            while let rest = enumerator.nextObject() as? DataSnapshot {
                self.events.append(rest)
            }
            self.makeLoadingView(visible: false)
            self.eventsTableView.reloadData()
        }){ (error) in
            print(error.localizedDescription)
            self.activityIndicator.stopAnimating()
        }
    }
    
    func returnImage(eventName: String) -> UIImage? {
        let eventName = eventName.lowercased().replacingOccurrences(of: " ", with: "").replacingOccurrences(of: "-", with: "")
        return UIImage(named: eventName)
    }
    
    func openEventURL(url: String) {
        if let url = URL(string: url) {
            UIApplication.shared.open(url)
        }
    }
}

extension EventsVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return events.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EventsViewCell", for: indexPath) as! EventsViewCell
        let eventData = events[indexPath.row].value as! [String: String]
        let name = events[indexPath.row].key
        let date = eventData[Constants.EventsField.date]
        let description = eventData[Constants.EventsField.description]
        let price = eventData[Constants.EventsField.price]

        cell.eventName.text = name
        cell.eventDate.text = date
        cell.eventDescription.text = description
        cell.eventPrice.text = price
        cell.imageView?.image = returnImage(eventName: name)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedEvent = events[indexPath.row].value as! [String: String]
        let eventURL = selectedEvent[Constants.EventsField.url]!
        openEventURL(url: eventURL)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 165
    }
}
