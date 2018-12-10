//
//  FeedVC
//  Trendsy
//
//  Created by Michelle Ho on 12/8/18.
//  Copyright © 2018 Michelle Ho. All rights reserved.
//

import UIKit

class FeedVC: UIViewController {

    // MARK: Outlets
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let layout = collectionView.collectionViewLayout as? PinterestLayout {
            layout.delegate = self
        }
        collectionView.contentInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
      

        // Do any additional setup after loading the view.
    }
    
    // MARK: Properties
    let images = [#imageLiteral(resourceName: "image-14"), #imageLiteral(resourceName: "image-16"), #imageLiteral(resourceName: "image-5"), #imageLiteral(resourceName: "image-7"), #imageLiteral(resourceName: "image-9"), #imageLiteral(resourceName: "image-6"), #imageLiteral(resourceName: "image-12"), #imageLiteral(resourceName: "image-1"), #imageLiteral(resourceName: "image-13"), #imageLiteral(resourceName: "image-10"), #imageLiteral(resourceName: "image-15"), #imageLiteral(resourceName: "image-11"), #imageLiteral(resourceName: "image-2"), #imageLiteral(resourceName: "image-3"), #imageLiteral(resourceName: "image-8"), #imageLiteral(resourceName: "image-4")]
    
}

// MARK: flow layout delegate
extension FeedVC: PinterestLayoutDelegate {
    func collectionView(_ collectionView: UICollectionView, heightForPhotoAtIndexPath indexPath: IndexPath) -> CGFloat {
        let image = images[indexPath.item]
        let height = image.size.height / 3
        
        return height
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
        
        
        return cell
    }
    
    
}
