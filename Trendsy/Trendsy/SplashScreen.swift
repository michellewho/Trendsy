//
//  SplashScreen.swift
//  Trendsy
//
//  Created by Julia Bobrovskiy on 12/9/18.
//  Copyright © 2018 Michelle Ho. All rights reserved.
//

import Foundation
import UIKit
class SplashScreen: UIViewController {
    
    @IBOutlet weak var myView: UIView!
    
    @IBOutlet weak var myImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let up = UISwipeGestureRecognizer(target : self, action : #selector(SplashScreen.upSwipe))
        up.direction = .up
        self.myView.addGestureRecognizer(up)
        
    }
    
    @objc
    func upSwipe(){
        performSegue(withIdentifier: "segueToNavVC", sender: self)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
