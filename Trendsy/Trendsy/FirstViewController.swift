//
//  FirstViewController.swift
//  Trendsy
//
//  Created by Michelle Ho on 11/26/18.
//  Copyright © 2018 Michelle Ho. All rights reserved.
//
import UIKit
import OhhAuth

class FirstViewController: UIViewController {
    
    override func viewDidLoad() {
        
        //let id = getWOEID(location: "Redmond")
        
        // TWITTER API CODE
        var id = 2490383
        id = 1
        
        getTwitterLocData(id: id)
        
        
    }
    
    func getTwitterLocData(id: Int) {
        // Do any additional setup after loading the view, typically from a nib.
        let cc = (key: apiKey, secret: apiSecret)
        let uc = (key: accessToken, secret: accessTokenSecret)
        
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
                    print(arrayDataReturned)
                } catch {
                    print("Error deserializing JSON: \(error)")
                }
            }
        }
        task.resume()
    }
    
    func getWOEID(location: String) -> (Int, Int) {
        
        // YAHOO WOEID API CODE
        let cc = (key: YaConsumerKey, secret: YaClientSecret)
        let test = "https://query.yahooapis.com/v1/public/yql?q=select+*+from+geo.places+where+text%3D%22" + location + "%22&format=json"
        var req = URLRequest(url: URL(string: test)!)
        var idState = 0
        var idCity = 0
        req.oAuthSign(method: "GET", consumerCredentials: cc)
        
        let task = URLSession(configuration: .ephemeral).dataTask(with: req) { (data, response, error) in
            var id1 = 0
            var id2 = 0;
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
                                if let places = results["place"] as? NSArray {
                                    let swiftArray: [Any] = places.compactMap({ $0 })
                                    if let loc = swiftArray[0] as? [String : Any] {
                                        if let locData = loc["admin1"] as? [String : Any] {
                                            let stateNum = Int((locData["woeid"] as! NSString).floatValue)
                                            idState = stateNum
                                            id1 = stateNum
                                        }
                                        if let locData = loc["locality1"] as? [String : Any] {
                                            let cityNum = Int((locData["woeid"] as! NSString).floatValue)
                                            idCity = cityNum
                                            id2 = cityNum
                                        }
                                    }
                                }
                            }
                        }
                        
                    }

                } catch {
                    print("Error deserializing JSON: \(error)")
                }
                DispatchQueue.main.async {
                    idState = id1
                    idCity = id2
                    StateID = id1
                    CityID = id2
                }
            }
        }
        task.resume()
        
        return (idState, idCity)
    }
    
}
