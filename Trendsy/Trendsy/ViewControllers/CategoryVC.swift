//
//  SecondViewController.swift
//  Trendsy
//
//  Created by Michelle Ho on 11/26/18.
//  Copyright © 2018 Michelle Ho. All rights reserved.
//

import UIKit
import CoreLocation

class CategoryVC: UIViewController, UITableViewDataSource {
    
    var appData = AppData.shared
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return appData.categories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellReuseIdentifier")! as! CustomTableViewCell
        
        if(appData.categories.count > indexPath.row) {
            cell.category.text = appData.categories[indexPath.row]
        }
        
        return cell
    }
}
