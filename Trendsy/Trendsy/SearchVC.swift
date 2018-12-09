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
     //  var recentSearch = ""
     //   if(searchedElement.count == 0) {
      //      recentSearch = appData.locations[indexPath.row]
     //   } else {
     //       recentSearch = searchedElement[indexPath.row]
      //  }
      //  if(!appData.searchRecents.contains(recentSearch)) {
      //     appData.searchRecents.append(recentSearch)
      //  }
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
