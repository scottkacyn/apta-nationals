//
//  PhotosViewController.swift
//  APTA Nationals
//
//  Created by Scott Kacyn on 2/23/15.
//  Copyright (c) 2015 New Coast Ventures. All rights reserved.
//

import UIKit

class PhotosViewController: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var logo: UIImageView!
    
    var originalImageView: PFImageView!
    var fullScreenImageView: UIImageView!
    var photos = [[String:AnyObject]]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Add the Braxton Hop Eagle logo to the nav bar
        logo = UIImageView(frame: CGRect(x: self.view.frame.width/2-40, y: 0, width: 80, height: 40))
        logo.contentMode = UIViewContentMode.ScaleAspectFit
        logo.image = UIImage(named: "logo.png")
        navigationController?.navigationBar.addSubview(logo)

        var query = PFQuery(className:"Photo")
        query.findObjectsInBackgroundWithBlock {
            (objects: [AnyObject]!, error: NSError!) -> Void in
            if error == nil {
                
                // The find succeeded. Set location objects and reload annotations
                var tempPhotos = [[String:AnyObject]]()
                for object in objects {
                    var photo = [String:AnyObject]()
                    photo["image"] = object["image"]
                    tempPhotos.append(photo)
                }
                
                self.photos = tempPhotos
                self.collectionView.reloadData()
                
            } else {
                // Log details of the failure
                NSLog("Error: %@ %@", error, error.userInfo!)
            }
        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Collection View Delegate Methods
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        NSLog("Photos: %d", photos.count)
        return (section < 0 || section >= 1) ? 0 : photos.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let photo = photos[indexPath.row]
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("PhotoCell", forIndexPath: indexPath) as UICollectionViewCell
        
        let imageView = cell.viewWithTag(1) as PFImageView
        imageView.contentMode = UIViewContentMode.ScaleAspectFill
        imageView.image = nil
        imageView.file = photo["image"] as PFFile
        imageView.loadInBackground()
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        let cell = collectionView.cellForItemAtIndexPath(indexPath) as UICollectionViewCell!
        
        originalImageView = cell.viewWithTag(1) as PFImageView
        
        fullScreenImageView = UIImageView()
        fullScreenImageView.contentMode = UIViewContentMode.ScaleAspectFit
        fullScreenImageView.backgroundColor = UIColor(white: 0, alpha: 0.9)
        fullScreenImageView.image = originalImageView.image
        
        let tempPoint = CGRect(x: originalImageView.center.x, y: originalImageView.center.y, width: 0, height: 0)
        let startingPoint = self.view.convertRect(tempPoint, fromView: self.collectionView.cellForItemAtIndexPath(indexPath))
        fullScreenImageView.frame = startingPoint
        self.view.addSubview(fullScreenImageView)
        
        UIView.animateWithDuration(0.2, animations: { () -> Void in
            self.fullScreenImageView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        })
        
        let imageTapped: Selector = "fullScreenImageViewTapped:"
        let singleTap = UITapGestureRecognizer(target: self, action: imageTapped)
        singleTap.numberOfTapsRequired = 1
        singleTap.numberOfTouchesRequired = 1
        fullScreenImageView.addGestureRecognizer(singleTap)
        fullScreenImageView.userInteractionEnabled = true
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        var size = self.view.frame.width/2-20
        return CGSize(width: size, height: size)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 10, bottom: 30, right: 10)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func fullScreenImageViewTapped (gestureRecognizer: UIGestureRecognizer) {
        let point = self.view.convertRect(originalImageView.bounds, fromView: originalImageView)
        let view = gestureRecognizer.view? as UIImageView
        view.backgroundColor = UIColor.clearColor()
        
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            view.frame = point
            view.alpha = 0
        }) { (finished) -> Void in
            self.fullScreenImageView.removeFromSuperview()
            self.fullScreenImageView = nil
        }
    }

}
