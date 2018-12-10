//
//  FirstViewController.swift
//  Trendsy
//
//  Created by Michelle Ho on 11/26/18.
//  Copyright © 2018 Michelle Ho. All rights reserved.
//
import UIKit
import OhhAuth

class JSONController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //print("TEST")
        //getTweetsWithHashtag(searchTopic: "SeduceMeIn4Words")
        let value = getTweetsWithHashtag(searchTopic: "Sports", numTweetsReturned: 5)
        print(value)
    }
    
    
    func getTweetsWithHashtag(searchTopic: String, numTweetsReturned: Int) -> Array<(name: String, text: String, url: String)> {
        let cc = (key: apiKey, secret: apiSecret)
        let uc = (key: accessToken, secret: accessTokenSecret)
        //let search = "SeduceMeIn4Words"
        let searchValue = searchTopic.replacingOccurrences(of: " ", with: "%20", options: .literal, range: nil)
        var req = URLRequest(url: URL(string: "https://api.twitter.com/1.1/search/tweets.json?q=" + searchValue + "&result_type=popular")!)
        
        req.oAuthSign(method: "GET", consumerCredentials: cc, userCredentials: uc)
        
        let dispatchGroup = DispatchGroup()
        dispatchGroup.enter()
        let task = URLSession(configuration: .ephemeral).dataTask(with: req) { (data, response, error) in
            var arrayDataReturned = [(name: String, text: String, url: String)]()
            if let error = error {
                print(error)
            }
            else if let data = data {
                
                do {
                    let json = try JSONSerialization.jsonObject(with: data) as? [String: Any]
                    //print(json!["statuses"])
                    let arrayObj = json!["statuses"] as? [[String : Any]]
                    // GET NAME
                    var i = 0
                    while (i < numTweetsReturned) {
                        // GET NAME
                        let user = arrayObj![i]["user"] as? [String : Any]
                        let name = user!["screen_name"] as? String ?? ""
                        // GET TEXT
                        let text = arrayObj![i]["text"] as? String ?? ""
                        // GET URL
                        let urlNum = arrayObj![i]["id_str"] as? String ?? ""
                        let urlId = user!["id_str"] as? String ?? ""
                        let url = "https://twitter.com/" + urlId + "/status/" + urlNum
                        // ADD TO ARRAY
                        arrayDataReturned.append((name: name, text: text, url: url))
                        i = i + 1
                    }
                } catch {
                    print("Error deserializing JSON: \(error)")
                }
                TweetsReturned = arrayDataReturned
            }
            dispatchGroup.leave()
            //print(arrayDataReturned)
            //print(TweetsReturned)
            //print(type(of: TweetsReturned))
        }
        task.resume()
        dispatchGroup.wait()
        return TweetsReturned
    }
    
    func dispatchFunc(givenLocation: String) -> Array<(name: String, url: String)>{
        let group = DispatchGroup()
        var currWOEID = -1
        // change spaces so they can work in URL
        let location = givenLocation.replacingOccurrences(of: " ", with: "%20", options: .literal, range: nil)
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
                        if(json != nil) {
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
        return Hashtags
        //-----------------------------------
    }
}
