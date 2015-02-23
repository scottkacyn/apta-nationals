//
//  InfoViewController.swift
//  APTA Nationals
//
//  Created by Scott Kacyn on 2/22/15.
//  Copyright (c) 2015 New Coast Ventures. All rights reserved.
//

import UIKit

class InfoViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    var logo: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Add the Braxton Hop Eagle logo to the nav bar
        logo = UIImageView(frame: CGRect(x: self.view.frame.width/2-40, y: 0, width: 80, height: 40))
        logo.contentMode = UIViewContentMode.ScaleAspectFit
        logo.image = UIImage(named: "logo.png")
        navigationController?.navigationBar.addSubview(logo)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - TableView Delegate & DataSource
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0 {
            return 2
        } else {
            return 4
        }
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Tournament Director John Noble"
        } else {
            return "More Information"
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("CellIdentifier", forIndexPath: indexPath) as UITableViewCell
        cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        
        if indexPath.section == 0 {
            cell.textLabel?.text = self.textForContactInfo(indexPath.row) }
        else {
            cell.textLabel?.text = self.textForMoreInfo(indexPath.row)
        }
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                if (UIApplication.sharedApplication().canOpenURL(NSURL(string: "tel:8472265030")!)) {
                    UIApplication.sharedApplication().openURL(NSURL(string: "tel:8472265030")!)
                } else {
                    UIAlertView(title: "Not Supported!", message: "In-app phone calls not supported on your device", delegate: self, cancelButtonTitle: nil, otherButtonTitles: "OK").show()
                }

            } else if indexPath.row == 1 {
                let subject = "APTA Nationals Question".stringByAddingPercentEscapesUsingEncoding(NSASCIIStringEncoding)
                let email = "jyn1968@comcast.net".stringByAddingPercentEscapesUsingEncoding(NSASCIIStringEncoding)
                let url = NSURL(string: String(format: "mailto:?to=%@&subject=%@", email!, subject!))
                
                if (UIApplication.sharedApplication().canOpenURL(url!)) {
                    UIApplication.sharedApplication().openURL(url!)
                } else {
                    UIAlertView(title: "Not Supported!", message: "We can't open the email client on your device", delegate: self, cancelButtonTitle: nil, otherButtonTitles: "OK").show()
                }
            }
        } else {
            self.performSegueWithIdentifier("infoDetailSegue", sender: indexPath.row)
        }
    }

    
    func textForContactInfo (row: Int) -> String {
        switch (row) {
        case 0:
            return "847-226-5030"
        case 1:
            return "jyn1968@comcast.net"
        default:
            return ""
        }
    }
    
    func textForMoreInfo (row: Int) -> String {
        switch (row) {
        case 0:
            return "Hotels"
        case 1:
            return "Sponsors"
        case 2:
            return "Volunteer Info"
        case 3:
            return "New Coast Ventures"
        default:
            return ""
        }
    }
    

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let controller = segue.destinationViewController as InfoDetailViewController
        let number = sender as Int
        controller.number = number
    }

}
