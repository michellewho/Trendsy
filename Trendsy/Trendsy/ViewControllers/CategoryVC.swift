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
    let locationManager = CLLocationManager()
    var searchCity = "Seattle"
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
    
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
            
            let geoCoder = CLGeocoder()
            let location = locations.last
            geoCoder.reverseGeocodeLocation(location!, completionHandler:
                {
                    placemarks, error -> Void in
                    
                    // Place details
                    guard let placeMark = placemarks?.first else { return }
                    
                    if let city = placeMark.subAdministrativeArea {
                        self.searchCity = city
                        print(city)
                    }
            })
            
        } else {
            print("No coordinates")
        }
   
    }
    
    func locationManager(_ mantager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}

