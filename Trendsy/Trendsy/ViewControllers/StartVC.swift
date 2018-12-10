//
//  StartVC.swift
//  Trendsy
//
//  Created by Michelle Ho on 12/9/18.
//  Copyright © 2018 Michelle Ho. All rights reserved.
//

import UIKit

class StartVC: UIViewController {

    @IBOutlet var myView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let tap = UITapGestureRecognizer(target: self, action: #selector(StartVC.handleTap))
        myView.addGestureRecognizer(tap)
        
    }
    
    @objc
    func handleTap(sender: UITapGestureRecognizer? = nil) {
        performSegue(withIdentifier: "segueToNav", sender: self)
    }
    
}
