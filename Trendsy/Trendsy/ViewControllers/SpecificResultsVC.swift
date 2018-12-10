//
//  SpecificResults.swift
//  Trendsy
//
//  Created by Julia Bobrovskiy on 12/9/18.
//  Copyright © 2018 Michelle Ho. All rights reserved.
//
import Foundation
import UIKit

class SpecificResultsVC: UIViewController {
    var appData = AppData.shared
    
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        
        super.viewDidLoad()
        tableView.delegate = self
        appData.searchButtonClicked = false
    }

}

extension SpecificResultsVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return appData.specificTweets.count
    }
    
    // Function Populates rows with data depending on user selections/searches
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCell.CellStyle.subtitle, reuseIdentifier: "specificTweetCell")
        
        cell.textLabel?.text = appData.specificTweets[indexPath.row]
        cell.textLabel?.font = UIFont(name: "Avenir Next-Bold", size: 16)
        cell.detailTextLabel?.text = appData.specificTweetText[indexPath.row]
        cell.detailTextLabel?.font = UIFont(name: "Avenir Next", size: 13)
        
        cell.detailTextLabel?.numberOfLines = 5
        cell.detailTextLabel?.lineBreakMode = NSLineBreakMode.byWordWrapping
        
        var font = UIFont(name: "Thonburi-Light", size: 15)!
        if(appData.selectedScope == 1) {
            font = UIFont(name: "Thonburi-Light", size: 25)!
        }
        cell.textLabel?.font = font
        
        cell.layer.masksToBounds = true
        cell.layer.cornerRadius = 4
        cell.layer.borderWidth = 1
        cell.layer.shadowOffset = CGSize(width: -1, height: 1)
        let borderColor: UIColor = UIColor(red:0.24, green:0.43, blue:0.89, alpha:1.0)
        cell.layer.borderColor = borderColor.cgColor
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Open tweet in twitter
        let link = appData.specificTweetLinks[indexPath.row]
        if let url = URL(string: link) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
}
