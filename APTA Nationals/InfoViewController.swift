//
//  InfoViewController.swift
//  APTA Nationals
//
//  Created by Scott Kacyn on 2/22/15.
//  Copyright (c) 2015 New Coast Ventures. All rights reserved.
//

import UIKit

class InfoViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
            return 5
        } else {
            return 4
        }
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Contact"
        } else {
            return "More Information"
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("CellIdentifier", forIndexPath: indexPath) as UITableViewCell
        
        if indexPath.section == 0 {
            cell.textLabel?.text = self.textForContactInfo(indexPath.row)
        }
        else
        {
            cell.textLabel?.text = self.textForMoreInfo(indexPath.row)
            cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        }
        return cell
    }
    
    func textForContactInfo (row: Int) -> String {
        switch (row) {
        case 0:
            return "Thursday - Sunday, March 5-8, 2015"
        case 1:
            return "Chicago, IL"
        case 2:
            return "Tournament Director John Noble"
        case 3:
            return "847-226-5030"
        case 4:
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
            return "Club Info"
        default:
            return ""
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
