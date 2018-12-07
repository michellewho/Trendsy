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
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let cc = (key: apiKey, secret: apiSecret)
        let uc = (key: accessToken, secret: accessTokenSecret)
        
        var req = URLRequest(url: URL(string: "https://api.twitter.com/1.1/trends/place.json?id=1")!)
        
        req.oAuthSign(method: "GET", consumerCredentials: cc, userCredentials: uc)
        
        let task = URLSession(configuration: .ephemeral).dataTask(with: req) { (data, response, error) in
            
            if let error = error {
                print(error)
            }
            else if let data = data {
                print(String(data: data, encoding: .utf8) ?? "Does not look like a utf8 response :(")
            }
        }
        task.resume()
    }
    
}
