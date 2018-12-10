//
//  FeedVC
//  Trendsy
//
//  Created by Michelle Ho on 12/8/18.
//  Copyright © 2018 Michelle Ho. All rights reserved.
//

import UIKit
import CoreLocation

class FeedVC: UIViewController {

    // MARK: Outlets
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var appData = AppData.shared
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let layout = collectionView.collectionViewLayout as? PinterestLayout {
            layout.delegate = self
        }
        collectionView.contentInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
      
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        
        getData()
    }
    
    func getData() {
        let instanceOfJson = JSONController()
        let jsonData = instanceOfJson.dispatchFunc(givenLocation: appData.location)
        appData.feedLocationData = jsonData
    }
    
    // MARK: Properties
    let images = [#imageLiteral(resourceName: "image-14"), #imageLiteral(resourceName: "image-16"), #imageLiteral(resourceName: "image-5"), #imageLiteral(resourceName: "image-7"), #imageLiteral(resourceName: "image-9"), #imageLiteral(resourceName: "image-6"), #imageLiteral(resourceName: "image-12"), #imageLiteral(resourceName: "image-1"), #imageLiteral(resourceName: "image-13"), #imageLiteral(resourceName: "image-10"), #imageLiteral(resourceName: "image-15"), #imageLiteral(resourceName: "image-11"), #imageLiteral(resourceName: "image-2"), #imageLiteral(resourceName: "image-3"), #imageLiteral(resourceName: "image-8"), #imageLiteral(resourceName: "image-4")]
    let colors = [#colorLiteral(red: 0.9568627477, green: 0.6588235497, blue: 0.5450980663, alpha: 1), #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1), #colorLiteral(red: 0.6605881282, green: 0.7568627596, blue: 0.2349528379, alpha: 1), #colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1), #colorLiteral(red: 0.721568644, green: 0.8862745166, blue: 0.5921568871, alpha: 1), #colorLiteral(red: 0.7074245761, green: 0.60451609, blue: 1, alpha: 1), #colorLiteral(red: 1, green: 0.6767398715, blue: 0.08016745001, alpha: 1), #colorLiteral(red: 0.9411764741, green: 0.4980392158, blue: 0.3529411852, alpha: 1), #colorLiteral(red: 0.8549019694, green: 0.250980407, blue: 0.4784313738, alpha: 1), #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1), #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1), #colorLiteral(red: 0.3913371566, green: 0.6759066779, blue: 1, alpha: 1), #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1), #colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1), #colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1), #colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1)]
    
}

// MARK: flow layout delegate
extension FeedVC: PinterestLayoutDelegate {
    func collectionView(_ collectionView: UICollectionView, heightForPhotoAtIndexPath indexPath: IndexPath) -> CGFloat {
        let image = images[indexPath.item]
        let height = image.size.height / 3
        
        return height
    }
    
   
}

extension FeedVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("enter")
        let link = appData.feedLocationData[indexPath.row].url
        if let url = URL(string: link) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
}


// MARK: data source
extension FeedVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "photoCell", for: indexPath) as! PhotoCell
        
        
        let image = images[indexPath.item]
        cell.imageView.image = image
        
//        let instanceOfJson = JSONController()
//        let jsonData = instanceOfJson.dispatchFunc(givenLocation: appData.location)
//        appData.feedLocationData = jsonData
        cell.tweet.text = appData.feedLocationData[indexPath.item].name.uppercased()
        return cell
    }
    
    
}

extension FeedVC: CLLocationManagerDelegate {
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
                        self.appData.location = city
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

