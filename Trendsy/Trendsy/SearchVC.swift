//
//  SearchVC.swift
//  Trendsy
//
//  Created by Michelle Ho on 12/4/18.
//  Copyright © 2018 Michelle Ho. All rights reserved.
//

import UIKit

class SearchVC: UIViewController {
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    var appData = AppData.shared
    
    var searchedElement = [String]()
    var isSearching = false

    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        searchBar.scopeButtonTitles = ["Hashtags", "Location", "Categories"]
        appData.selectedScope = 0
    }
    
    // Functions make the keyboard slide away when user decides to scroll
    // through  the options.
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        searchBar.endEditing(true)
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
    }
}

extension SearchVC: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(isSearching) {
            return searchedElement.count
        } else if (appData.selectedScope == 0) {
            return appData.hashtags.count
        } else if (appData.selectedScope == 1) {
            return appData.locations.count
        } else {
            return appData.categoriesToSearch.count
        }
    }
    
    // Function Populates rows with data depending on user selections/searches
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
        if(isSearching) {
            cell.textLabel?.text = searchedElement[indexPath.row]
        } else if appData.selectedScope == 0 && appData.hashtags.count > indexPath.row {
            cell.textLabel?.text = appData.hashtags[indexPath.row]
        } else if appData.selectedScope == 2 && appData.categoriesToSearch.count > indexPath.row {
            cell.textLabel?.text = appData.categoriesToSearch[indexPath.row]
        } else {
            cell.textLabel?.text = appData.locations[indexPath.row]
        }
        return cell
    }
    
    // Tracks what user selects as interesting in the search function.
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let instanceOfJson = FirstViewController()
        appData.top5Username = []
        appData.links = []
        appData.top5 = []
        // get data for location
        if(appData.selectedScope == 1) {
            var currentCell = ""
            if(isSearching) {
                currentCell = searchedElement[indexPath.row]
            } else {
                currentCell = appData.locations[indexPath.row]
            }
            print("this is the country:", currentCell)
            let jsonData = instanceOfJson.dispatchFunc(givenLocation: currentCell)
            var index = 0
            while index <= 5 {
                appData.top5Username.append(jsonData[index].name)
                appData.links.append(jsonData[index].url)
                appData.top5.append(" ")
                index += 1
            }
        // get data for hashtags
        } else if (appData.selectedScope == 0) {
            print("need json to work")
            var index = 0
            while index <= 5 {
                appData.top5Username.append("Sample Username")
                appData.links.append("https://twitter.com/kyliecosmetics/status/1071123613745475584")
                appData.top5.append("Sample Tweet")
                index += 1
            }
        // get data for categories
        } else {
            print("need json to work")
            var index = 0
            while index <= 5 {
                appData.top5Username.append("Sample Username")
                appData.links.append("https://twitter.com/kyliecosmetics/status/1071123613745475584")
                appData.top5.append("Sample Tweet")
                index += 1
            }
            
        }
        
        performSegue(withIdentifier: "goToResults", sender: self)
        
    }
}

extension SearchVC: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        //Hashtags
        if(appData.selectedScope == 0){
             searchedElement = appData.hashtags.filter({$0.lowercased().prefix(searchText.count) == searchText.lowercased()})
        // Location
        }else if(appData.selectedScope == 1) {
            searchedElement = appData.locations.filter({$0.lowercased().prefix(searchText.count) == searchText.lowercased()})

        // Categories
        } else {
              searchedElement = appData.categoriesToSearch.filter({$0.lowercased().prefix(searchText.count) == searchText.lowercased()})
        }
        
        isSearching = true
        tableView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        isSearching = false
        appData.selectedScope = selectedScope
        tableView.reloadData()
    }
    
    
}
