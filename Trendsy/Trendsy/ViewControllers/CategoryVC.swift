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
        
        appData.inCat = true
        appData.inSearch = false
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
            var catText = appData.categories[indexPath.row]
            if(catText.prefix(1) != "#") {
                catText.insert("#", at: catText.startIndex)
            }
            cell.textLabel?.text = catText.replacingOccurrences(of: " ", with: "")
            cell.textLabel?.textColor = #colorLiteral(red: 0.4504547798, green: 0.5101969303, blue: 0.689423382, alpha: 1)
            cell.textLabel?.font = UIFont(name: "AvenirNext-DemiBold", size: 20)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100.0
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
            while index < 5 && index < jsonData.count {
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

