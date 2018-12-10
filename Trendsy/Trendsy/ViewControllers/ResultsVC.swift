//
//  ResultsVC.swift
//  Trendsy
//
//  Created by Julia Bobrovskiy on 12/8/18.
//  Copyright © 2018 Michelle Ho. All rights reserved.
//
import Foundation
import UIKit


class ResultsVC: UIViewController {
    var appData = AppData.shared
    
//    @IBOutlet weak var tableView: UITableView!
    
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        print("entered")
        
    }
    
}

extension ResultsVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    // Function Populates rows with data depending on user selections/searches
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCell.CellStyle.subtitle, reuseIdentifier: "resultsCell")
        cell.textLabel?.text = appData.top5Username [indexPath.row]
        cell.detailTextLabel?.text = appData.top5[indexPath.row]
        
        
        cell.detailTextLabel?.numberOfLines = 0
        cell.detailTextLabel?.lineBreakMode = NSLineBreakMode.byWordWrapping
        
        cell.textLabel?.textAlignment = .center
        
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
        return 100.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Open tweet in twitter
        
        appData.specificTweets = []
        appData.specificTweetText = []
        appData.specificTweetLinks = []
        
        var currentCell = appData.top5Username[indexPath.row]
        let instanceOfJson = JSONController()
        let firstChar = currentCell.prefix(1)
        if(firstChar == "#") {
            var splitCell = currentCell.split(separator: "#")
            currentCell = String(splitCell[0])
        }
        let jsonData = instanceOfJson.getTweetsWithHashtag(searchTopic: currentCell, numTweetsReturned: 5)
        var index = 0
        if(jsonData.count == 0) {
            let alert = UIAlertController(title: "Sorry!", message: "No Twitter Data for " + currentCell, preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Search Another Term", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        } else {
            while index < 5 {
                appData.specificTweets.append(jsonData[index].name)
                appData.specificTweetText.append(jsonData[index].text)
                appData.specificTweetLinks.append(jsonData[index].url)
                print(jsonData[index].url)
                index += 1
            }
            performSegue(withIdentifier: "segueSpecificResults", sender: self)
        }
    }
}
