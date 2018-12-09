//
//  FirstViewController.swift
//  Trendsy
//
//  Created by Michelle Ho on 11/26/18.
//  Copyright © 2018 Michelle Ho. All rights reserved.
//

import UIKit
import OhhAuth


class FirstViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    var cellColor = true
    
    let reuseIdentifier = "collectionReuseIdentifier"
    var items = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11"]

    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dispatchFunc()
        
        
    }
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // get a reference to our storyboard cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath as IndexPath) as! CustomCollectionViewCell
        
//        cell.label.text = self.items[indexPath.item]
        cell.backgroundColor = UIColor.cyan
        cell.layer.borderColor = UIColor.black.cgColor
        cell.layer.borderWidth = 1
        cell.layer.cornerRadius = 8
        
        //        print(collectionView.frame.size.width)
        //        print(collectionView.frame.size.height)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // handle tap events
        print("You selected cell #\(indexPath.item)!")
    }
    
    
    func getTweetsWithHashtag(searchTopic: String) {
        let cc = (key: apiKey, secret: apiSecret)
        let uc = (key: accessToken, secret: accessTokenSecret)
        //let search = "SeduceMeIn4Words"
        
        var req = URLRequest(url: URL(string: "https://api.twitter.com/1.1/search/tweets.json?q=" + searchTopic + "&result_type=popular")!)
        
        req.oAuthSign(method: "GET", consumerCredentials: cc, userCredentials: uc)
        
        let task = URLSession(configuration: .ephemeral).dataTask(with: req) { (data, response, error) in
            
            if let error = error {
                print(error)
            }
            else if let data = data {
                var newData = String(data: data, encoding: .utf8) ?? "Does not look like a utf8 response :("
                print(newData)
                print(String(data: data, encoding: .utf8) ?? "Does not look like a utf8 response :(")
                
                do {
                    let json = try JSONSerialization.jsonObject(with: data) as? [String: Any]
                    for item in json! {
                        print ("ITEM", item)
                        if let inner = item.value as? [String: Any] {
                            print ("INNER", inner)
                            /*
                             if let results = inner["results"] as? [String : Any] {
                             if let places = results["place"] as? NSArray {
                             let place = places[0] as! NSDictionary
                             var woeid = Int((place["woeid"] as! NSString) as String)!
                             currWOEID = woeid
                             }
                             }
                             */
                        }
                    }
                } catch {
                    print("Error deserializing JSON: \(error)")
                }
                
            }
        }
        
        task.resume()
    }
    
    func dispatchFunc() {
        let group = DispatchGroup()
        var location = "United States"
        var currWOEID = -1
        // change spaces so they can work in URL
        location = location.replacingOccurrences(of: " ", with: "%20", options: .literal, range: nil)
        //-----------------------------
        group.enter()
        //------------------------------
        
        func woeID() {
            // YAHOO WOEID API CODE
            let cc = (key: YaConsumerKey, secret: YaClientSecret)
            let test = "https://query.yahooapis.com/v1/public/yql?q=select+*+from+geo.places+where+text%3D%22" + location + "%22&format=json"
            var req = URLRequest(url: URL(string: test)!)
            req.oAuthSign(method: "GET", consumerCredentials: cc)
            
            let task = URLSession(configuration: .ephemeral).dataTask(with: req) { (data, response, error) in
                if let error = error {
                    print(error)
                }
                else if let data = data {
                    //print(String(data: data, encoding: .utf8) ?? "Does not look like a utf8 response :(")
                    do {
                        let json = try JSONSerialization.jsonObject(with: data) as? [String: Any]
                        for item in json! {
                            if let inner = item.value as? [String: Any] {
                                if let results = inner["results"] as? [String : Any] {
                                    let count = inner["count"] as? Int
                                    if count == 1 {
                                        let place = results as NSDictionary
                                        var word = place["place"] as! NSDictionary
                                        print ("WORD", word)
                                        let woeid = Int((word["woeid"] as! NSString) as String)!
                                        currWOEID = woeid
                                    } else {
                                        print ("RESULTS", results)
                                        if let places = results["place"] as? NSArray {
                                            print ("PLACES", places)
                                            let place = places[0] as! NSDictionary
                                            let woeid = Int((place["woeid"] as! NSString) as String)!
                                            currWOEID = woeid
                                        }
                                    }
                                }
                            }
                        }
                    } catch {
                        print("Error deserializing JSON: \(error)")
                    }
                }
                group.leave()
            }
            task.resume()
        }
        //---------------------------
        woeID()
        group.wait()
        group.enter()
        //---------------------------
        func twitterData() {
            let cc = (key: apiKey, secret: apiSecret)
            let uc = (key: accessToken, secret: accessTokenSecret)
            let id = currWOEID
            
            // REPLACE id=1 with the desired WOEID from YAHOO API
            var req = URLRequest(url: URL(string: "https://api.twitter.com/1.1/trends/place.json?id=" + String(id))!)
            
            req.oAuthSign(method: "GET", consumerCredentials: cc, userCredentials: uc)
            
            let task = URLSession(configuration: .ephemeral).dataTask(with: req) { (data, response, error) in
                var arrayDataReturned = [(name: String, url: String)]()
                if let error = error {
                    print(error)
                }
                else if let data = data {
                    do {
                        let json = try JSONSerialization.jsonObject(with: data) as? [[String: Any]]
                        print ("JSON RESPONSE", json)
                        for results in json! {
                            if let trends = results["trends"] as? NSArray {
                                let swiftArray: [Any] = trends.compactMap({ $0 })
                                //print(swiftArray)
                                for item in swiftArray {
                                    if let objItem = item as? [String : Any] {
                                        let n = objItem["name"] as? String ?? ""
                                        let u = objItem["url"] as? String ?? ""
                                        arrayDataReturned.append((name: n, url: u))
                                    }
                                }
                            }
                        }
                        Hashtags = arrayDataReturned
                    } catch {
                        print("Error deserializing JSON: \(error)")
                    }
                }
                group.leave()
            }
            task.resume()
        }
        //-----------------------------------
        
        twitterData()
        group.wait()
        print(CityID)
        print("HASHTAGS", Hashtags)
        group.notify(queue: .main) {
            print("Both functions complete")
        }
        //-----------------------------------
    }
}
