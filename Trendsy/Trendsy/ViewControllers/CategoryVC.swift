//
//  SecondViewController.swift
//  Trendsy
//
//  Created by Michelle Ho on 11/26/18.
//  Copyright © 2018 Michelle Ho. All rights reserved.
//

import UIKit
import CoreLocation

class CategoryVC: UIViewController {
    
    var appData = AppData.shared
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.reloadData()
        tableView.dataSource = self
    }
}

extension CategoryVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return appData.categories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellReuseIdentifier")!
        if(appData.categories.count > indexPath.row) {
            cell.textLabel?.text = appData.categories[indexPath.row]
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let instanceOfJson = JSONController()
        var currentCell = appData.categories[indexPath.row]
        let firstChar = currentCell.prefix(1)
        if(firstChar == "#") {
            var splitCell = currentCell.split(separator: "#")
            currentCell = String(splitCell[0])
        }
        let jsonData = instanceOfJson.getTweetsWithHashtag(searchTopic: currentCell, numTweetsReturned: 5)
        appData.specificTweets = []
        appData.specificTweetText = []
        appData.specificTweetLinks = []
        print(jsonData)
        var index = 0
        if(jsonData.count == 0) {
            let alert = UIAlertController(title: "Sorry!", message: "No Twitter Data for " + currentCell, preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Search Another Term", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        } else {
            while index < 5 {
//                open var specificTweets = [String]()
//                open var specificTweetText = [String]()
//                open var specificTweetLinks = [String]()
                
                appData.specificTweets.append(jsonData[index].name)
                appData.specificTweetText.append(jsonData[index].text)
                appData.specificTweetLinks.append(jsonData[index].url)
                index += 1
            }
            
        }
        performSegue(withIdentifier: "segueToTweets", sender: self)
    }
    
    
}

