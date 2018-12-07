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
        searchBar.scopeButtonTitles = ["All", "Recent Views"]
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
        if(isSearching && appData.selectedScope == 0) {
            return searchedElement.count
        }else if(appData.selectedScope == 1) {
            return appData.searchRecents.count
        } else {
            return appData.testSearches.count
        }
    }
    
    // Function Populates rows with data depending on user selections/searches
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
        if(isSearching) {
            // Looks at the array that maches constraints of search term
            cell.textLabel?.text = searchedElement[indexPath.row]
        } else if appData.selectedScope == 1 && appData.searchRecents.count > indexPath.row {
            cell.textLabel?.text = appData.searchRecents[indexPath.row]
        } else {
            // Populate table view with all the necessary data
            cell.textLabel?.text = appData.testSearches[indexPath.row]
        }
        return cell
    }
    
    // Tracks what user selects as interesting in the search function.
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var recentSearch = ""
        if(searchedElement.count == 0) {
            recentSearch = appData.testSearches[indexPath.row]
        } else {
            recentSearch = searchedElement[indexPath.row]
        }
        if(!appData.searchRecents.contains(recentSearch)) {
           appData.searchRecents.append(recentSearch)
        }
    }
}

extension SearchVC: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchedElement = appData.testSearches.filter({$0.lowercased().prefix(searchText.count) == searchText.lowercased()})
        if(appData.selectedScope == 1) {
            isSearching = false
        } else {
            isSearching = true
        }
        tableView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        appData.selectedScope = selectedScope
        print(searchedElement)
        print(appData.selectedScope)
        tableView.reloadData()
    }
}
