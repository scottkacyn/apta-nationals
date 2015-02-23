//
//  MapListViewController.swift
//  APTA Nationals
//
//  Created by Scott Kacyn on 2/23/15.
//  Copyright (c) 2015 New Coast Ventures. All rights reserved.
//

import UIKit

class MapListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIAlertViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    var locations = []
    var logo: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Add the Braxton Hop Eagle logo to the nav bar
        logo = UIImageView(frame: CGRect(x: self.view.frame.width/2-40, y: 0, width: 80, height: 40))
        logo.contentMode = UIViewContentMode.ScaleAspectFit
        logo.image = UIImage(named: "logo.png")
        navigationController?.navigationBar.addSubview(logo)
        
        var query = PFQuery(className:"Location")
        query.findObjectsInBackgroundWithBlock {
            (objects: [AnyObject]!, error: NSError!) -> Void in
            if error == nil {
                
                // The find succeeded. Set location objects and reload annotations
                self.locations = objects
                self.tableView.reloadData()
                
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

    @IBAction func toggleMapView(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: - TableView Delegate & DataSource
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return locations.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("LocationCell", forIndexPath: indexPath) as UITableViewCell
        let location: AnyObject = locations[indexPath.row]
        let locationName = location["title"] as String
        
        cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        cell.textLabel?.text = locationName
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let location: AnyObject = locations[indexPath.row]
        let address = location["address"] as String
        let city = location["city"] as String
        let state = location["state"] as String
        let zip = location["zip"] as String
        let fullAddress = String(format: "%@ %@, %@ %@", address, city, state, zip)
        
        let escapedAddress = fullAddress.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)
        let url = NSURL(string: NSString(format: "http://maps.google.com/maps?saddr=Current+Location&daddr=%@&directionsmode=driving", escapedAddress!))!
        
        if (UIApplication.sharedApplication().canOpenURL(url)) {
            UIApplication.sharedApplication().openURL(url)
        } else {
            UIAlertView(title: "Not Supported!", message: "Directions are not supported on your device", delegate: self, cancelButtonTitle: nil, otherButtonTitles: "OK").show()
        }
    }

}
