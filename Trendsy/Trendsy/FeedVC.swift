//
//  FeedVC.swift
//  Trendsy
//
//  Created by Michelle Ho on 12/8/18.
//  Copyright © 2018 Michelle Ho. All rights reserved.
//

import UIKit


class FeedVC: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    var cellColor = true
    
    let reuseIdentifier = "collectionReuseIdentifier"
    var items = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11"]
    
    
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
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
        
        cell.label.text = self.items[indexPath.item]
        cell.backgroundColor = UIColor.white
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

}
