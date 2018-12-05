//
//  SecondViewController.swift
//  Trendsy
//
//  Created by Michelle Ho on 11/26/18.
//  Copyright © 2018 Michelle Ho. All rights reserved.
//

import UIKit
import CoreLocation
import Alamofire

class CategoryVC: UIViewController, UITableViewDataSource {
    
    var appData = AppData.shared
    let locationManager = CLLocationManager()
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        
//        let baseurl = "https://api.twitter.com/1.1/trends/place.json?id=1"
//        Alamofire.request(baseurl).responseJSON { response in
//            let value = response.result.value
//            print(value)
//        }
        
    }
    
    
    @IBAction func button(_ sender: Any) {
        locationManager.requestLocation()
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

extension CategoryVC: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let lat = locations.last?.coordinate.latitude, let long = locations.last?.coordinate.longitude {
            print("\(lat),\(long)")
        } else {
            print("No coordinates")
        }
    }
    func locationManager(_ mantager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}

