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
        
        var tweetText = appData.specificTweets[indexPath.row]
        if(tweetText.prefix(1) != "#") {
            tweetText.insert("#", at: tweetText.startIndex)
        }
        
        cell.textLabel?.textColor = #colorLiteral(red: 0.3362201505, green: 0.3416172901, blue: 0.5676157995, alpha: 1)
        cell.detailTextLabel?.textColor = #colorLiteral(red: 0.4504547798, green: 0.5101969303, blue: 0.689423382, alpha: 1)
        
        cell.textLabel?.text = tweetText.replacingOccurrences(of: " ", with: "")
        cell.textLabel?.font = UIFont(name: "AvenirNext-DemiBold", size: 16)
        cell.detailTextLabel?.text = appData.specificTweetText[indexPath.row]
        cell.detailTextLabel?.font = UIFont(name: "Avenir Next", size: 13)
        
        cell.detailTextLabel?.numberOfLines = 5
        cell.detailTextLabel?.lineBreakMode = NSLineBreakMode.byWordWrapping
        
        
        cell.layer.masksToBounds = true
        cell.layer.cornerRadius = 4
        cell.layer.borderWidth = 1
        cell.layer.shadowOffset = CGSize(width: -1, height: 1)
        cell.layer.borderColor = #colorLiteral(red: 0.656817491, green: 0.7432596004, blue: 1, alpha: 1)
        
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
